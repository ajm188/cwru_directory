# CWRUDirectory

Make queries with the Case Western Reserve University [directory listing](https://webapps.case.edu/directory/index.html) in Ruby!

Inspired by/derived from [the Python implementation](https://github.com/brenns10/caseid).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cwru_directory'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cwru_directory

## Usage

### Configuration

CWRUDirectory currently recognizes the following configuration options
(you can set as many other options as you like, they just won't do anything):

```ruby
CWRUDirectory.configure do |config|
  # case_id and password are used to authenticate with SSO to
  # be able to access information not available to the public
  config.case_id = 'abc123'
  config.password = 'my-password'

  # get_all_info is used to tell CWRUDirectory to actually get
  # that extra info not available to the public
  config.get_all_info = true
end
```

### Queries

CWRUDirectory has two ways to query the directory, simple and advanced.
Both return a hash, which maps the categories to the sets of results for
each category.

#### The Result hash

As mentioned above, each element of a result set is a hash, which has the following keys:
  * `:name`
  * `:phone_number`
  * `:email`
  * `:department`

If you run this with the `get_all_info` config option set, you will also
get some of the following, possibly more:
  * `"Case Network ID"` - this one is always present (as far as I can tell)
  * `"Title"` 
  * `"Mail Stop Location Code"` - uhhh. I guess if you need that...

#### Simple Queries

Simple queries allow you to search by single search string in a given search mode.

```ruby
CWRUDirectory.simple 'my_search_string'
# second argument is the search mode, defaults to :regular,
# :phonetic is the only other option the Case directory supports
CWRUDirectory.simple 'my_search_string', :phonetic
```

#### Advanced Queries

You can also make "advanced" queries with many more attributes. The Case directory has the
following attributes:
  * `surname` - last name
  * `givenname` - first name
  * `department` - this isn't listed for most entries, so probably won't be that helpful to you
  * `location` - ??? if you figure out what this actually is, let me know
  * `category` - one of `'STUDENT', 'FACULTY', 'STAFF', 'EMERITI', 'ALL'`
  * `search_text` - this is the same as the search text used in the simple queries
  * `search_method` - same as simple queries

Just pass in a hash of whichever ones you want to use; the rest will default to empty strings,
except for `category` (default is `'ALL'`) and `search_method` (defaults to `:regular`)

```ruby
CWRUDirectory.advanced({surname: 'Mason', givenname: 'Andrew'})
```

That's all for now folks! LDAP probably coming soon.
