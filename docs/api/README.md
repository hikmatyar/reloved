Reloved API v1.0
=======

Every API call returns a JSON response. The only exception is with multimedia, where both download and upload can be raw data (like png or jpg).

# Data Types

	ARRAY<TYPE> - An array value that's made of TYPEs such as INTEGERs ('1,2,3')
	INTEGER - An integer value such as '2' or '50'
	NUMBER - A number value such as '2' or '5.3'
	STRING - A string value
	STRING[X] - A string value that supports up-to X characters

# Error codes

Error responses are standardized:

	{ "error": 1000 }

List of possible error codes:

	[standard]
    0    - no error (default)
    1000 - invalid input parameter
    1001 - missing input parameter
    1020 - access denied
    1021 - session is required
    1022 - session is expired
    1023 - session is invalid
    2000 - unknown error
    2001 - API version is not supported

# Authentication

Every API call requires a valid session, but accounts are created automatically so it's completely transparent to end-users.

Session parameters are standardized:

	STRING _u [R] = user ID (required)
	STRING _s [R] = session ID (required)
	STRING _v [O] = client version ID (optional)
	INTEGER _t [O] = timestamp (optional, but highly recommended to avoid agressive caching on certain client devices)
	STRING _l [O=en] = language code (optional)

## Login

Performs a login or creates an account if possible (type=auto) and the account doesn't exist. Returns a new session

	/login
    
    Parameters:
        [session]
        STRING type [R] - Login type. Use 'auto' to automatically create an account
        STRING token [R] - Public token (username)
        STRING secret [R] - Private token (password)
        INTEGER length [O=0] - Session length in seconds. 0 - automatic.
        STRING scope [O=mobile] - Scope ID (allows to have multiple sessions on different devices)
        STRING os [O=ios] - Platform
        STRING[40] hash [O] - Sha1 checksum of salt, type, public and private arguments
    
    Returns:
        { "error": 0, "session": "12345678", "user": "1231" }
    
    Errors:
        [standard]

## Logout

Performs a logout. The session is not valid after the call.

	/logout
    
    Parameters:
        [_v, _t, _u, _s]
    
    Returns:
        { "error": 0 }
    
    Errors:
        [standard]

# Browse

Returns a feed (potentially filtered) and settings that are stored server-side (like shipping info, available countries, user profile info).

	/browse
	
	Parameters:
		[session]
		STRING state [O=null] - State that is managed by the server and was returned with the previous response
		STRING direction [O=forward] - Browse 'forward' or 'backward'? Only used with the state parameter
		INTEGER limit [O=100] - Maximum number of posts to return
	
	Returns:
		{
			"error": 0,
			// Cursor position for UI. 'start', 'middle' or 'end'
			"cursor": "start",
			// State that can be used with the next request
			"state": "eyJhIjowLCJiIjowfQ==",
			// Prefix for media resources. Possible redirect to a CDN on separate domain
			"prefix": "http://api.relovedapp.co.uk/media/download/",
			// All the possible brands. Only included if state is missing/invalid.
			"brands": [
				{ "id": 1, "name": "Gucci" }
			],
			// All the possible dress colors. Only included if state is missing/invalid.
			"colors": [
				{ "id": 1, "name": "Red" }
			],
			// All the possible countries. Only included if state is missing/invalid.
			"countries": [
				{ "id": 1, "code": "GB", "name": "Great Britain" },
				{ "id": 1, "code": "DE", "name": "Germany" },
			],
			// All the possible currencies. Only included if state is missing/invalid. '*' is wildcard.
			"currencies": [
				{ "id": 1, "code": "GBP", "country": "*" }
			],
			// All the possible delivery methods. Only included if state is missing/invalid. '*' is wildcard.
			"deliveries": [
				{ "id": 1, "country": "GB", "name": "Normal delivery", "price": 10000, "currency": "GBP" },
				{ "id": 1, "country": "*", "name": "EU delivery", "price": 20000, "currency": "GBP" }
			],
			// All the possible dress sizes. Only included if state is missing/invalid.
			"sizes": [
				{ "id": 1, "name": "Size 10" }
			],
			// All the possible dress types. Only included if state is missing/invalid.
			"types": [
				{ "id": 1, "name": "Night" }
			],
			// Posts, all or max of limit.
			"posts": [
				{
					"id": 1,
					"user": 10,
					"status": 1,
					"mod": 12345678,
					"brand": 1,
					"color": 1,
					"condition": 1,
					"type": 1,
					"size": 1,
					"materials": "...",
					"price": 12345,
					"price_o": 23456,
					"currency": "GBP",
					"title": "...",
					"fit": "...",
					"notes": "...",
					// Optional
					"editorial": "..."
				}
			],
			"users": [
				{ "id": 10, "name": "Abc", "media": 123 }
			]
		}
	
	Errors:
		[standard]

# Posts

TDB:

## Search

	/post/search
	
	Parameters:
		[session]
	
	Returns:
		{ "error": 0 }
	
	Errors:
		[standard]

## Post List

	/post/list
	
	Parameters:
		[session]
	
	Returns:
		{ "error": 0 }
	
	Errors:
		[standard]

## Post States

	/post/states
	
	Parameters:
		[session]
	
	Returns:
		{ "error": 0 }
	
	Errors:
		[standard]

## Post Details

	/post/details
	
	Parameters:
		[session]
	
	Returns:
		{ "error": 0 }
	
	Errors:
		[standard]

## Post Comments

	/post/comments
	
	Parameters:
		[session]
		INTEGER id [R] - Post ID
		STRING state [O] - State
		INTEGER limit [O=100] - Maximum number of comments to return
	
	Returns:
		{
			"error": 0,
			// Cursor position for UI. 'start', 'middle' or 'end'
			"cursor": "start",
			// State that can be used with the next request
			"state": "eyJhIjowLCJiIjowfQ==",
			"comments": [
				{ "id": 1, "user": 10, "date": 434, "mod": 434, "message": "..." }
			],
			"users": [
				{ "id": 10, "name": "Abc", "media": 123 }
			]
		}
	
	Errors:
		[standard]

## Create/Edit Comment

	/post/comment
	
	Parameters:
		[session]
		INTEGER id [R] - Post ID
		INTEGER cid [O] - Comment ID (no ID means a new comment)
		INTEGER status [O] - Status (1 - inactive, 2 - active)
		STRING message [O] - Message
		
		STRING state [O] - State
		INTEGER limit [O=100] - Maximum number of comments to return
	
	Returns:
		/post/comments
	
	Errors:
		[standard]

# Me

API calls for updating personal information and posts.

## Update Info

	/user/edit
	
	Parameters:
		[session]
		INTEGER size [O] - Dress size ID
		INTEGER media [O] - Profile picture ID
		STRING email [O] - Email address
		STRING phone [O] - Phone number
		STRING first_name [O] - First name,
		STRING last_name [O] - Last name,
		INTEGER country [O] - Country ID
		STRING city [O] - City
		STRING address [O] - Address
		STRING zipcode [O] - Zipcode
	
	Returns:
		{ "error": 0 }
	
	Errors:
		[standard]

## Create Post

	/user/post/create
	
	Parameters:
		[session]
		INTEGER condition [R] - Dress condition ID
		INTEGER type [R] - Dress type ID
		INTEGER size [R] - Dress size ID
		INTEGER brand [R] - Dress brand ID
		ARRAY<INTEGER> colors [R] - List of dress color IDs
		ARRAY<INTEGER> media [R] - List of media IDs
		STRING materials [R] - Dress materials
		STRING title [R] - Post title
		STRING fit [R] - Fit info
		STRING notes [R] - Notes for the post
		STRING editorial [O] - Editorial text
		INTEGER price [R] - Integer value with a price (100 = 1.00)
		INTEGER price_original [R] - Integer value with a price (105 = 1.05)
		STRING[3] currency [R] - 3 letter currency code, such as 'GBP'
		ARRAY<STRING> tags [R] - List of tag names
		
	Returns:
		{ "error": 0 }
	
	Errors:
		[standard]

## Edit Post

	/user/post/edit
	
	Parameters:
		[session]
		INTEGER id [R] - Post ID
		INTEGER status [O] - New post status (1 - unlisted, 2 - listed)
	
	Returns:
		{ "error": 0 }
	
	Errors:
		[standard]

# Checkout

TDB:

## Checkout

	/checkout
	
	Parameters:
		[session]
	
	Returns:
		{ "error": 0 }
	
	Errors:
		[standard]

## Checkout Status

	/checkout/status
	
	Parameters:
		[session]
	
	Returns:
		{ "error": 0 }
	
	Errors:
		[standard]

# Multimedia

Media items are handled separately from posts and comments, so that it can handle background uploads before a post is formally created.

Item status codes are standardized:

    0 - Inactive (Item was deleted by the user/admin)
    1 - Uploading (Item upload in progress)
    2 - Uploaded (Item upload is complete, but the server hasn't processed it yet)
    3 - Active (Item is available)
    4 - Invalid (Item doesn't exist or is not available to the user)

## Create Item

Creates a new multimedia item with metadata.

	/media/create
	
	Parameters:
		[session]
		STRING mime [R] - Mime type
        INTEGER size [R] - File size in bytes
        STRING[32] csum [R] - MD5 checksum of the file
	
	Returns:
		{ "error": 0, "id": "1234567890" }
	
	Errors:
		[standard]

## Query Item Status

Allows to query about item status and upload progress.

	/media/status
	
	Parameters:
		[session]
		INTEGER id [R] - Item ID
	
	Returns:
		{ "error": 0, "status": 2, "size": 12345 }
	
	Errors:
		[standard]

## Upload Item

Uploads data for an item.

	/media/upload
	
	Parameters:
		[session]
		INTEGER id [R] - Item ID
		INTEGER offset [O=0] - Item data offset
		
		[MULTIPART DATA = "data" file]
	
	Returns:
		{ "error": 0, "status": 2, "size": 12345 }
	
	Errors:
		[standard]

## Download Item

Downloads an item. Only API call that doesn't return a JSON error.

	/media/download/{ID}
	
	Parameters:
		[session]
        STRING[2] size [O=o] - Preferred size ("o" - original, "s" - small, "m" - medium, "l" - large)
    
    Returns:
        Raw data or HTTP error
    
    Errors:
        HTTP 403 (No permission), HTTP 404 (Not found), HTTP 500 (Unknown problem)

