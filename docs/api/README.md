Reloved API v1.0
=======

Every API call returns a JSON response. The only exception is with multimedia, where both download and upload can be raw data (like png or jpg).

# Error codes

Error responses are standardized:

	{ "error": 1000 }

List of possible error codes:

	[standard]
    0    - no error
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

## Login

Performs a login or creates an account if possible (type=auto) and the account doesn't exist. Returns a new session

	/login
    
    Parameters:
        [session]
        type [R] - Login type. Use 'auto' to automatically create an account
        token [R] - Public token (username)
        secret [R] - Private token (password)
        scope [O=mobile] - Scope ID (allows to have multiple sessions on different devices)
        os [O=ios] - Platform
        hash [O] - Sha1 checksum of salt, type, public and private arguments
    
    Returns:
    
        { "error": 0, "session": "12345678", "user": 1231 }
    
    Errors:
    
        [standard]

## Logout

Performs a logout. The session is not valid after the call.

	/logout
    
    Arguments:
        [_v, _t, _u, _s]
    
    Returns:
    
        { "error": 0 }
    
    Errors:
    
        [standard]

# Browse

TDB:

# Posts

TDB:

## Search

TDB:

## Post List

TDB:

## Post States

TDB: 

## Post Details

TDB:

## Post Comments

TDB:

# Me

TDB:

## Update Info

TDB:

## Create Post

TDB:

## Edit Post

TDB:

## Create Comment

TDB:

# Checkout

TDB:

## Begin Checkout

TDB:

## End Checkout

TDB: 

# Multimedia

TDB:

## Create Item

TDB:

## Upload Item

TDB: 

## Download Item

TDB:

