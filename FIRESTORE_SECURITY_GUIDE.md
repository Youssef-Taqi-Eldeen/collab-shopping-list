# Firestore Security Implementation Guide

## Overview
This document explains the implemented fix for the shopping list privacy issue where all lists were visible to all users.

## Problem
Previously, when a user created a shopping list or cart, it appeared to **all authenticated users** instead of only the owner and invited collaborators.

## Solution Implemented

### 1. Firebase Service (`lib/core/services/firebase_service.dart`)
Created a comprehensive Firebase service that implements proper filtering:

**Key Methods:**
- `getUserLists()` - Returns stream of lists where user is owner OR collaborator
- `getOwnedLists()` - Returns only lists owned by current user
- `getCollaboratedLists()` - Returns only lists where user is a collaborator
- `getUserCarts()` - Returns carts with proper filtering
- `createList()` - Creates a list with proper ownerId
- `addCollaboratorToList()` - Adds collaborators using arrayUnion
- `deleteList()` - Only allows owner to delete

**Filtering Logic:**
```dart
// Modern approach (Firebase SDK supports Filter.or)
.where(
  Filter.or(
    Filter('ownerId', isEqualTo: currentUserId),
    Filter('collaborators', arrayContains: currentUserId),
  ),
)

// Fallback approach (for older SDK versions)
// Merges two separate queries: one for owned, one for collaborated
```

### 2. Firestore Security Rules (`firestore.rules`)
Created comprehensive security rules:

```javascript
// Lists and Carts
allow read: if isAuthenticated() && (
  isOwner(resource.data.ownerId) || 
  isCollaborator(resource.data.collaborators)
);

allow create: if isAuthenticated() && 
  request.resource.data.ownerId == request.auth.uid;

allow update: if isAuthenticated() && (
  isOwner(resource.data.ownerId) || 
  isCollaborator(resource.data.collaborators)
);

allow delete: if isAuthenticated() && 
  isOwner(resource.data.ownerId);
```

**This ensures:**
- Users can only read lists they own or collaborate on
- Only authenticated users can create lists
- Created lists automatically have the creator as owner
- Only owners can delete lists
- Both owners and collaborators can update lists

### 3. Profile Screen (`lib/features/profile/presentation/view/profile_screen.dart`)
Updated to display filtered lists:

**Features:**
- Shows only lists where user is owner or collaborator
- Displays owner/collaborator badge
- Allows creating new lists
- Allows deleting owned lists
- Real-time updates via StreamBuilder

**Implementation:**
```dart
StreamBuilder<List<ShoppingListModel>>(
  stream: _firebaseService.getUserLists(),
  builder: (context, snapshot) {
    // Display filtered lists
  },
)
```

### 4. Cart Screen Updates
- Added `_ensureCartExists()` method
- Creates cart document with proper structure:
  ```json
  {
    "ownerId": "user-uid",
    "items": [],
    "collaborators": [],
    "createdAt": Timestamp,
    "updatedAt": Timestamp
  }
  ```

### 5. Add User Screen (Already Implemented)
The existing `add_user_screen.dart` already handles:
- Finding users by email
- Adding collaborators to cart using `arrayUnion`
- Proper error handling

## Data Structure

### Shopping List Document
```json
{
  "name": "Weekly Groceries",
  "ownerId": "abc123",
  "collaborators": ["def456", "ghi789"],
  "createdAt": Timestamp,
  "updatedAt": Timestamp
}
```

### Cart Document
```json
{
  "ownerId": "abc123",
  "items": [],
  "collaborators": ["def456"],
  "createdAt": Timestamp,
  "updatedAt": Timestamp
}
```

## Verification Steps

1. **Deploy Firestore Rules:**
   ```bash
   firebase deploy --only firestore:rules
   ```

2. **Test Scenarios:**
   
   a. **Create a List:**
   - User A creates a list
   - ✓ User A can see the list
   - ✗ User B cannot see the list
   
   b. **Add Collaborator:**
   - User A adds User B as collaborator
   - ✓ User B can now see the list
   - ✗ User C still cannot see the list
   
   c. **Delete List:**
   - ✓ User A (owner) can delete
   - ✗ User B (collaborator) cannot delete
   
   d. **Update List:**
   - ✓ Both User A and User B can update items
   
   e. **Multiple Lists:**
   - User A creates List 1
   - User B creates List 2
   - User A adds User B to List 1
   - ✓ User A sees: List 1 (owner)
   - ✓ User B sees: List 1 (collaborator), List 2 (owner)
   - ✗ User A does NOT see List 2

## How to Use

### For Users (App Behavior):

1. **Create a list:**
   - Go to Profile tab
   - Click "New List" button
   - Enter list name
   - You become the owner

2. **Add collaborators:**
   - Go to Cart screen
   - Click person+ icon
   - Enter collaborator's email
   - They get access to your cart

3. **View your lists:**
   - Profile tab shows all lists you own or collaborate on
   - Badge indicates "Owner" or "Collaborator"

### For Developers:

1. **Use FirebaseService for all list operations:**
   ```dart
   final firebaseService = FirebaseService();
   
   // Get user's lists
   Stream<List<ShoppingListModel>> lists = firebaseService.getUserLists();
   
   // Create a list
   String listId = await firebaseService.createList(name: 'My List');
   
   // Add collaborator
   await firebaseService.addCollaboratorToList(
     listId: listId,
     collaboratorUid: 'user-id',
   );
   ```

2. **Never query Firestore directly without filtering by user:**
   ```dart
   // ❌ BAD - Shows all lists to everyone
   FirebaseFirestore.instance.collection('lists').snapshots();
   
   // ✓ GOOD - Shows only user's lists
   firebaseService.getUserLists();
   ```

## Migration Notes

If you have existing lists in Firestore without `ownerId` or `collaborators` fields:

1. **Add migration script** (run once):
   ```dart
   Future<void> migrateLists() async {
     final lists = await FirebaseFirestore.instance
         .collection('lists')
         .get();
     
     for (var doc in lists.docs) {
       if (!doc.data().containsKey('ownerId')) {
         await doc.reference.update({
           'ownerId': 'default-user-id', // Set appropriate owner
           'collaborators': [],
         });
       }
     }
   }
   ```

2. **Or delete existing lists** and start fresh.

## Security Benefits

1. **Data Privacy:** Users can only access their own data
2. **Access Control:** Fine-grained control over who can read/write
3. **Server-Side Enforcement:** Rules enforced by Firebase, not just client
4. **Audit Trail:** createdAt/updatedAt timestamps for tracking
5. **Scalable:** Works efficiently even with thousands of lists

## Common Issues & Solutions

### Issue: "Missing or insufficient permissions"
**Solution:** Deploy the firestore.rules file using `firebase deploy --only firestore:rules`

### Issue: Filter.or not supported
**Solution:** The FirebaseService has a fallback that merges two queries for older SDK versions

### Issue: Lists not showing up
**Solution:** 
- Check that lists have `ownerId` field
- Check that user is authenticated
- Verify security rules are deployed

### Issue: Can't delete collaborator's list
**Solution:** This is expected behavior - only owners can delete lists

## Next Steps

1. **Deploy Firestore Rules:**
   ```bash
   firebase deploy --only firestore:rules
   ```

2. **Test the App:**
   - Create multiple test accounts
   - Create lists as different users
   - Verify privacy between accounts
   - Test collaborator functionality

3. **Optional Enhancements:**
   - Add list sharing via email invite
   - Show collaborator names in list view
   - Add notification when added as collaborator
   - Implement list templates

## Summary

✅ **Implemented:**
- Firestore query filtering by owner/collaborator
- Security rules to enforce access control
- Profile screen with filtered list display
- Proper cart document structure

✅ **Result:**
- Users only see their own lists
- Collaborators have controlled access
- Server-side security enforcement
- Real-time sync for shared lists

The app now properly implements privacy and access control for shopping lists and carts!
