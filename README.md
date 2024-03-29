# Keeper!

### Objective
The goal is to create a simple bookkeeping API backend where users can
record financial transactions. These transactions can be either credit or debit
entries. The transactions can be optionally attributed to a contact (not a
mandatory relation). A contact is a simple record of (name, phone number).
The system must be idempotent and prevent duplicate entries.

[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop-hq/rubocop)
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
**Sidenote:** There are some images at the end of this file to see some calls in action

 #### Creating a User
 `http POST localhost:3000/api/v1/users`
 
    Response an id which will be used for interacting with transactions later
 ![Creating User](https://github.com/abhishekgupta5/keeper/blob/master/img/create_user.png?raw=true)
----
#### Creating a Contact
  `http POST localhost:3000/api/v1/contacts name="John Doe" phone_number="1234556"`
    
     It creates a Contact object which contains contact_id, name, and phone_number.
     Phone number can be empty but name is required.
     This contact_id is used to interact with transactions (optionally)
     Duplicate contact will not be created
   ![Creating Contact](https://github.com/abhishekgupta5/keeper/blob/master/img/create_contact.png?raw=true)
----
#### Creating a Transaction
  `http POST localhost:3000/api/v1/transactions uid:1 amount="123.45" transaction_type="credit" contact_id=1`
    
    It creates a Transaction object.
    All interactions to transactions expects a valid 'uid'(user->id) as a header.
    Amount needs to be more than 0,
    transaction_type must be either 'credit' or 'debit',
    contact_id can be removed since a transaction may or may not
    belong to a contact. However, if given, it should be valid.
    Duplicates will not be created (amount is also part of duplicate set)
    All the above cases will be handled gracefully.
  ![Creating Transaction](https://github.com/abhishekgupta5/keeper/blob/master/img/create_transaction.png?raw=true)
----
#### Querying Transactions -
  `http GET localhost:3000/api/v1/transactions uid:1 page=1 per_page=4 contact_id=15 transaction_type='debit'`
    
    It returns a paginated response sorted by created_at DESC
    respecting below filters.
    Responses can be filtered by a single contact_id
    or/and transaction_types(debit or credit) or/and pages.
    'page'(page number) and 'per_page'(transactions per page).
  ![Querying Transactions](https://github.com/abhishekgupta5/keeper/blob/master/img/getting_filtered_transaction.png?raw=true)

#### DB schema
![Querying Transactions](https://github.com/abhishekgupta5/keeper/blob/master/img/db_schema.png?raw=true)  

###  Scope of improvements
*  These are all the APIs. Feel free to play around - remove, add, modify params/headers as you wish. I have tried to do proper error handling at most places but there's room for more.
* The Pagination that is supported is simple limit/offset based. While this works for normal ranges, note that if page number (offset) is too large, this will be inefficient because Postgres actually scans the table to shift the offset. Better methods exist to attain this.
* While all the required queries will use index, there's some redundancy in transactions table, which I think I need to think about more.
* There's a flaky test which is failing sometimes only when the whole suite runs because of before blocks. Will fix it. Correctness-wise it's fine.
