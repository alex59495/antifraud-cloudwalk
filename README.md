# README
## Tasks

The answers to the tasks 3.1 and 3.2 can be found inside the folder `_answers`

## Project
### Stack

- Ruby on Rails 6.1.4
- Ruby 3.0.1
- PostgreSQL

**Gems**
- devise (4.8.0) & simple_token_authentification (1.17.0) => Authentification
- rspec_rails (5.0.0) & factory_bot_rails (6.2.0) & rspec_json_expectations (2.2.0) => TDD
- jbuilder (2.7) => API format
- faker (2.18.0) => Fake data
### Prerequisites

If you don't already have them :

- Install ruby 3.0.1 `rbenv install 3.0.1 && rbenv global 3.0.1`
- Install PostgreSQL

**Install the dependencies**

```
bundle install
yarn install
```
### Database

- Create the database : `rails db:create`
- Run the migrations : `rails db:migrate`
- Run the seed to populate the data : `rails db:seed`

The seed will create instances of : 
- Customers,
- Merchants
- Transactions 

_based on the exercices (see `db/seed.rb` & `./transactions-sample.csv`)_

and **one User who will be able to use the API.**

### Running

To run the project run the command

```bash
rails s
```

Then use Postman (or another tool) to send the requests to the API endpoints.

### API Endpoints

- **Endpoint POST**
```
POST  api/v1/transactions
```

- **Headers**

_Those data come from the seed (User able to use the API)_
```json
{
"Content-Type": "application/json",
"X-User-Email": "test@test.com",
"X-User-Token": "m2_T9AkghFbMYQqc46--"
}
```
- **Body**
```json
{
"transaction_id" : 2342357,
"merchant_id" : 29744,
"user_id" : 97051,
"card_number" : "434505******9116",
"transaction_date" : "2019-11-31T23:16:32.812632",
"transaction_amount" : 501.49,
"device_id" : 285475
}
```

- **Response OK**

```json
{ 
"transaction_id" : 2342357,
"recommendation" : "approve"
}
```
- **Response Not OK**

```json
{ 
"transaction_id" : 2342357,
"recommendation" : "deny"
}
```

- **Endpoint PATCH**

_For updating chargeback status_ 
_Here i'm not respecting the rails standards (/:id) because we don't need the id inside the url. We'll send it inside the request to keep the same behaviour we have in the post method_
```
PATCH  api/v1/transactions
```

- **Headers**

```json
{
"Content-Type": "application/json",
"X-User-Email": "test@test.com",
"X-User-Token": "m2_T9AkghFbMYQqc46--"
}
```

- **Body**
```json
{
"transaction_id" : 2342357,
"chargeback": true
}
```

- **Response**
```json
{
"transaction_id" : 2342357,
"chargeback": true
}
```

### API Fraud explanation

The API is a really simple example of Fraud verification system. There are two main verification from the fraud system :
- **Verification of chargebacks** : If the user has alredy transactions with chargeback, the transacation recommendation is `denied`
- **Point system based on existing user's transactions and his habit of consumming** : 
If the user has already made a transaction :
  - in less than 10 minutes => 10 points
  - in less than 30 minutes => 6 points
  - in less than 1 hour minutes => 3 points
  - in less than 6 hours => 2 points
  - in less than 1 day => 1 point

If the amount of the transaction is :  
  - superior to 5x the average of other transactions from this user => 6 points
  - superior to 3x the average of other transactions from this user => 3 points
  - superior to 2x the average of other transactions from this user => 2 points

If the score > 5, the transaction recommendation is `denied`


### Examples

- **Should be approved**
```json
{
"transaction_id" : 21323421000,
"merchant_id" : 32954,
"user_id" : 6,
"card_number" : "428267******9019",
"transaction_date" : "2019-12-02T20:44:48",
"transaction_amount" : 100,
"device_id" : "757451"
}
```

- **Should be denied**
```json
{
"transaction_id" : 21323421001,
"merchant_id" : 8111,
"user_id" : 3157,
"card_number" : "535081******2584",
"transaction_date" : "2019-12-03T01:50:22",
"transaction_amount" : 100,
"device_id" : ""
}
```

**explication** : This user already have a chargeback => We deny this transaction

- **Should be denied**
```json
{
"transaction_id" : 21323421002,
"merchant_id" : 8111,
"user_id" : 14625,
"card_number" : "523421******9747",
"transaction_date" : "2019-11-21T16:32:42",
"transaction_amount" : 100,
"device_id" : "169566"
}
```

**explication** : This user already have a transaction for the same day with the same merchant but with a different card => We deny this transaction

- **Should be denied**
```json
{
"transaction_id" : 21323421003,
"merchant_id" : 32901,
"user_id" : 62541,
"card_number" : "511781******250",
"transaction_date" : "2019-11-04T10:31:09",
"transaction_amount" : 100,
"device_id" : ""
}
```

**explication** : This user made too many transactions (2 < 10min & 1 < 30min. Score = 2 * 5 + 1 * 3 = 13 >= 10) => We deny this transaction

- **Should be denied**
```json
{
"transaction_id" : 21323421004,
"merchant_id" : 31960,
"user_id" : 95855,
"card_number" : "539090******9370",
"transaction_date" : "2019-12-20T17:46:44",
"transaction_amount" : 1200,
"device_id" : "589318"
}
```

**explication** : This user made a transaction more than 5x superior to his average amount transaction (Score = 10 >= 10 )=> We deny this transaction


### Testing

For testing we're using rspec, to launch the tests locally, run:

```bash
rspec
```

### Areas for improvement

- Be clearer about the Fraud system in the API response. With the actual system we only know if the transaction is approved or denied but we don't know about the reason. It acts likes a black box for the API user.
- This example only show a really small sample of how the logic could be implemented but we could improve the score calcul with more robust models or even AI.


