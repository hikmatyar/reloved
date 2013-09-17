Reloved API v1.0
=======

Every API call returns a JSON response. The only exception is with multimedia, where both download and upload can be raw data (like png or jpg).

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

	_u [R] = user ID (required)
	_s [R] = session ID (required)
	_v [O] = client version ID (optional)
	_t [O] = timestamp (optional, but highly recommended to avoid agressive caching on certain client devices)
	_l [O=en] = language code (optional)

## Login

Performs a login or creates an account if possible (type=auto) and the account doesn't exist. Returns a new session

	/login
    
    Parameters:
        [session]
        type [R] - Login type. Use 'auto' to automatically create an account
        token [R] - Public token (username)
        secret [R] - Private token (password)
        length [O=0] - Session length
        scope [O=mobile] - Scope ID (allows to have multiple sessions on different devices)
        os [O=ios] - Platform
        hash [O] - Sha1 checksum of salt, type, public and private arguments
    
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
		state [O=null] - State that is managed by the server and was returned with the previous response
		direction [O=forward] - Browse 'forward' or 'backward'? Only used with the state parameter
		limit [O=100] - Maximum number of posts to return
	
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
			]
	
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
	
	Returns:
		{ "error": 0 }
	
	Errors:
		[standard]

# Me

TDB:

## Update Info

	/user/details
	
	Parameters:
		[session]
	
	Returns:
		{ "error": 0 }
	
	Errors:
		[standard]

## Create Post

	/user/post/create
	
	Parameters:
		[session]
	
	Returns:
		{ "error": 0 }
	
	Errors:
		[standard]

## Edit Post

	/user/post/edit
	
	Parameters:
		[session]
	
	Returns:
		{ "error": 0 }
	
	Errors:
		[standard]

## Create Comment

	/user/comment/create
	
	Parameters:
		[session]
	
	Returns:
		{ "error": 0 }
	
	Errors:
		[standard]

# Checkout

TDB:

## Begin Checkout

	/checkout/begin
	
	Parameters:
		[session]
	
	Returns:
		{ "error": 0 }
	
	Errors:
		[standard]

## End Checkout

	/checkout/end
	
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
		mime [R] - Mime type
        size [R] - File size
        csum [R] - MD5 checksum of the file
	
	Returns:
		{ "error": 0, "id": "1234567890" }
	
	Errors:
		[standard]

## Query Item Status

Allows to query about item status and upload progress.

	/media/status
	
	Parameters:
		[session]
		id [R] - Item ID
	
	Returns:
		{ "error": 0, "status": 2, "size": 12345 }
	
	Errors:
		[standard]

## Upload Item

Uploads data for an item.

	/media/upload
	
	Parameters:
		[session]
		id [R] - Item ID
		offset [O=0] - Item data offset
		
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
        size [O=o] - Preferred size ("o" - original, "s" - small, "m" - medium, "l" - large)
    
    Returns:
        Raw data or HTTP error
    
    Errors:
        HTTP 403 (No permission), HTTP 404 (Not found), HTTP 500 (Unknown problem)

