# Parent/Child and Compound Object Handling in CollectionBuilder

## Overview
This document describes the parent/child relationship and compound object logic implemented in the UpdateCSV view for CollectionBuilder static sites.

## Implementation Date
November 2025

## Purpose
In CollectionBuilder workflows, compound objects (`compound_object` and `multiple` display templates) have parent records with multiple child records. Parent records typically don't have their own image files but need to display a representative image (usually from the first child) in collection browsing views.

## Functionality

### When It Runs
- **Mode**: CollectionBuilder only
- **Timing**: Step 3.7 in the `apply_all_updates()` method, after Azure URLs are populated
- **Trigger**: Automatic when "Apply All Updates" button is clicked

### Required CSV Columns
The logic requires the following columns to be present in the CSV:
- `objectid`: Unique identifier for each record
- `parentid`: Identifier linking child records to their parent (empty for parent records)
- `display_template`: Template type (compound_object, multiple, or other)
- `image_small`: URL to the small derivative image (optional, will be populated if missing)
- `image_thumb`: URL to the thumbnail derivative image (optional, will be populated if missing)

### Logic Flow

1. **Identify Parent Records**
   - Finds all rows where `parentid` is empty or NaN
   - These are considered parent records

2. **Filter for Compound Objects**
   - Only processes parents with `display_template` set to `compound_object` or `multiple`
   - Other parent records are skipped

3. **Find Children for Each Parent**
   - For each compound parent, searches for child records where `parentid` matches the parent's `objectid`

4. **Copy Derivative URLs (If Parent Fields Are Empty)**
   - If children exist, gets the **first child** in the dataset
   - Copies `image_small` from first child to parent **only if parent's image_small is empty**
   - Copies `image_thumb` from first child to parent **only if parent's image_thumb is empty**
   - **Protection**: Never overwrites existing custom images (e.g., poster images)

### Example

#### Before Processing
| objectid | parentid | display_template | image_small | image_thumb |
|----------|----------|-----------------|-------------|-------------|
| album_01 |          | compound_object |             |             |
| album_01_p1 | album_01 | image | https://.../album_01_p1_SMALL.jpg | https://.../album_01_p1_TN.jpg |
| album_01_p2 | album_01 | image | https://.../album_01_p2_SMALL.jpg | https://.../album_01_p2_TN.jpg |

#### After Processing
| objectid | parentid | display_template | image_small | image_thumb |
|----------|----------|-----------------|-------------|-------------|
| album_01 |          | compound_object | https://.../album_01_p1_SMALL.jpg | https://.../album_01_p1_TN.jpg |
| album_01_p1 | album_01 | image | https://.../album_01_p1_SMALL.jpg | https://.../album_01_p1_TN.jpg |
| album_01_p2 | album_01 | image | https://.../album_01_p2_SMALL.jpg | https://.../album_01_p2_TN.jpg |

## URL Update Protection

### Compound Objects Are Protected During URL Updates
When processing files through the File Selector and updating Azure URLs, compound objects receive special protection:

**Compound Objects (`display_template: compound_object` or `multiple`) are completely skipped** during Step 1 URL updates because:
- They have no object content of their own
- Their `object_location` should remain empty
- Their `image_small` and `image_thumb` may contain custom representations (e.g., poster images)
- Child objects provide the actual content

This prevents the workflow from accidentally overwriting custom compound object images when processing individual child files.

## Logging

The implementation includes detailed logging:
- Info messages when processing compound parent/child relationships
- Info messages when derivative URLs are copied to parents
- Info messages when copies are skipped due to existing parent values
- Summary count of how many parent records were updated
- Warnings if required columns (`objectid` or `parentid`) are missing
- Info message if no parent/child updates were needed

### Log Examples
```
[INFO] Processing parent/child relationships for compound_object and multiple display templates...
[INFO] Processing parent with display_template='compound_object', objectid=album_01
[INFO] Copied image_small from child to parent (objectid=album_01)
[INFO] Copied image_thumb from child to parent (objectid=album_01)
[INFO] Updated 1 parent record(s) with child derivative URLs
```

```
[INFO] Skipped image_small copy - parent already has value (objectid=show_poster)
[INFO] Skipped image_thumb copy - parent already has value (objectid=show_poster)
```

## Edge Cases Handled

1. **Missing Columns**: If `objectid` or `parentid` columns don't exist, logs a warning and skips processing
2. **Empty Parent ObjectID**: Skips parents with empty/NaN `objectid` values
3. **Wrong Display Template**: Only processes parents with `compound_object` or `multiple` display templates
4. **No Children**: If a parent has no children, no updates are made
5. **Empty Child Values**: Only copies from child if child has a non-empty value
6. **Existing Parent Values**: Never overwrites existing parent derivative URLs (protects custom images)
7. **Multiple Children**: Always uses the **first child** (index order) for derivative URLs
8. **File Matching**: During file processing, compound objects are completely skipped to prevent URL overwriting

## Code Location

- **File**: `views/update_csv_view.py`
- **Method**: `apply_all_updates()`
- **Step**: 3.7 (parent/child derivative copying)
- **Step**: 1 (compound object protection during file matching)

## Future Enhancements

Potential improvements for consideration:
1. Allow user to select which child to use (not always first)
2. Support for selecting "best" child based on criteria (file size, specific naming pattern)
3. Configurable behavior (enable/disable via settings)
4. Handling of multiple parent levels (grandparent/parent/child hierarchies)
5. Option to force-update parent derivatives even when custom images exist

## Related Documentation

- CollectionBuilder compound object documentation: https://collectionbuilder.github.io/cb-docs/docs/metadata/compound-objects/
- Azure Storage URL structure: See `views/storage_view.py` upload logic
- CSV column mapping: See `_data/verified_CSV_headings_for_GCCB_projects.csv`
- Subset Processing Safeguard: See README.md
