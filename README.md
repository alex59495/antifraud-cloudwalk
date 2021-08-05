# README
## Tasks

The answers to the tasks 3.1 and 3.2 can be found inside the folder `_answers`

## Project

### Overview
#### Stack

- Ruby on Rails 6.1.4
- Ruby 3.0.1
- PostgreSQL

**Gems**
- devise (4.8.0) & simple_token_authentification (1.17.0) => Authentification
- rspec_rails (5.0.0) & factory_bot_rails (6.2.0) & rspec_json_expectations (2.2.0) => TDD
- jbuilder (2.7) => API format
- faker (2.18.0) => Fake data
#### Prerequisites

If you don't already have them :

- Install ruby 3.0.1 `rbenv install 3.0.1 && rbenv global 3.0.1`
- Install PostgreSQL

Install the dependencies

`bundle install`
`yarn install`
#### Database

- Create the database : `rails db:create`
- Run the migrations : `rails db:migrate`
- Run the seed to populate the data : `rails db:seed`

The seed will create the instances of Customers, Merchants and Transactions based on the exercices `(see ./transactions-sample.csv)`

#### Running

To run the project run the command

```bash
rails s
```

Then use Postman (or another tool) to send the requests to the API endpoints.

To create a new instance of transaction send a POST request to

```
http://localhost:3000/api/v1/transactions
```

with the format

```json
{
"transaction_id" : 2342357,
"merchant_id" : 29744,
"user_id" : 97051,
"card_number" : "434505******9116",
"transaction_date" : "2019-11-31T23:16:32.812632",
"transaction_amount" : 373,
"device_id" : 285475
}
```

the response will look like

```json
{ 
"transaction_id" : 2342357,
"recommendation" : "approve"
}
```
if it is approved by the Fraud verification system and

```json
{ 
"transaction_id" : 2342357,
"recommendation" : "deny"
}
```
if it is denied
#### Testing

To launch the tests locally, run:

```bash
rspec
```


