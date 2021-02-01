# Keeper!

### Tools used
* Ruby 2.6.5 / Rails 6.0 (Only the necessary part) for app
* PostgreSQL 10 as DB
* Other relevant gems - Rspec, byebug etc
* RuboCop for Linting. [Style guide](https://github.com/rubocop-hq/ruby-style-guide)
* Overcommit for git hooks

### Building is simple
* `git clone git@github.com:abhishekgupta5/keeper.git`
* `brew install rvm`
* `rvm install 2.6.5 && rvm use 2.6.5`
* `cd <project directory>`
* `bundle install`
* [Install PostgreSQL](https://www.postgresql.org/docs/10/tutorial-install.html) (>9)
* `rails db:setup`will initilize the DB and populate some random data from `seeds.rb` 
* `rails s` Starting the server
* Any client can be used to consume from the API. I used HTTPie and Postman

## API consumption
We have 3 models and tables. **User**, **Contact** and **Transactions**
 
 #### Creating a User - `http POST localhost:3000/api/v1/users`
    It returns an id which will be used for interacting with transactions later
----
#### Creating a Contact - `http POST localhost:3000/api/v1/contacts name="John Doe" phone_number="1234556"`
     It creates a Contact object which contains contact_id, name, and phone_number.
     Phone number can be empty but name is required.
     This contact_id is used to interact with transactions (optionally)
     Duplicate contact will not be created
----
#### Creating a Transaction -  `http POST localhost:3000/api/v1/transactions uid:1 amount="123.45" transaction_type="credit" contact_id=1`
    It creates a Transaction object.
    All interactions to transactions expects a valid 'uid'(user->id) as a header.
    Amount needs to be more than 0,
    transaction_type must be either 'credit' or 'debit',
    contact_id can be removed since a transaction may or may not
    belong to a contact. However, if given, it should be valid.
    Duplicates will not be created (amount is also part of duplicate set)
    All the above cases will be handled gracefully.
----
#### Querying Transactions - `http GET localhost:3000/api/v1/transactions uid:1 page=1 per_page=4 contact_id=15 transaction_type='debit'`
    It returns a paginated response sorted by created_at DESC
    respecting below filters.
    Responses can be filtered by a single contact_id
    or/and transaction_types(debit or credit) or/and pages.
    'page'(page number) and 'per_page'(transactions per page).

###  Scope of improvements
*  These are all the APIs. Feel free to play around - remove, add,  modify params/headers as you wish. I have tried to do proper handling at most places but there's room for more
* The Pagination that is supported is simple limit/offset based. While this works for normal ranges, it should be noted that if page number (offset) is too large, this will be inefficient because Postgres actually scans the table to shift the offset. Better methods exists to attain this.
* While all the required queries will use index, there's some redundancy in transactions table, which I think I need to think about more.
* There's a flaky test which is failing sometimes only when the whole suite runs because of before blocks. Will fix it. Correctness-wise it's fine.
