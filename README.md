# README
## Tasks

The answers to the tasks 3.1 and 3.2 can be found inside the folder `_answers`

## Project
### Stack

- Ruby on Rails 6.1.4
- Ruby 3.0.1
- PostgreSQL > 8.4

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

To run the project run the server with the command

```bash
rails s
```

Then use Postman (or another tool) to send the requests to the API endpoints. Be sure that the server is still running when sending the requests.

### API Endpoints

**Important ! For all the requests you have to add the credentials in the headers. Those credentials come from the user created in the seed.rb.**

- **Headers**

```json
{
"Content-Type": "application/json",
"X-User-Email": "test@test.com",
"X-User-Token": "m2_T9AkghFbMYQqc46--"
}
```

- **Endpoint POST**
```
POST  api/v1/transactions
```

**Body**
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

**Response OK**

```json
{ 
"transaction_id" : 2342357,
"recommendation" : "approve"
}
```
**Response Not OK**

```json
{ 
"transaction_id" : 2342357,
"recommendation" : "deny"
}
```

- **Endpoints GET**

_To get all the transaction ID_

```
GET api/v1/transactions
```

**Response**

```json
[
  {
    "id": 21323127
  },
  {
    "id": 21323129
  },
  {
    "id": 21320405
  },
  {
    "id": 21320406
  },
  "..."
]
```

_To verify if a transaction ID exists_


```
GET api/v1/transactions/:transaction_id
```

**Response OK**

```json
{
  "id": 21323127
},
```

**Response Not OK**

```json
{
  "error": "Couldn't find Transaction with 'id'=0101010101"
},
```


- **Endpoint PATCH**

_For updating chargeback status_ 
_Here i'm not respecting the rails standards (/:id) because we don't need the id inside the url. We'll send it inside the request to keep the same behaviour we have in the post method_
```
PATCH  api/v1/transactions
```

**Body**
```json
{
"transaction_id" : 2342357,
"chargeback": true
}
```

**Response**
```json
{
"transaction_id" : 2342357,
"chargeback": true
}
```

### API Fraud explanation

The API is a really simple example of Fraud verification system. There are three main verification from the fraud system :
- **Verification of chargebacks** : If the user has alredy transactions with chargeback, the transacation recommendation is `denied`
- **Verification of multiple cards** : If the user has alredy transactions with more than 2 cards or if it has already a transaction for the same day with the same merchant but with a different card, recommendation is `denied`
- **Point system based on existing user's transactions and his habit of consumming** : 
If the user has already made Y transaction :
  - in less than 10 minutes => **score += Y * 5 points**
  - between 10 and 30 minutes => **score += Y * 3 points**
  - between 30 minutes and 1 hour minutes => **score += Y * 2 points**
  - between 1 and 6 hours => **score += Y * 1.5 points**
  - between 6 hours and 1 day => **score += Y * 1 point**

If the amount of the transaction is :  
  - superior to 5x the average of other transactions from this user => **score += 10 points**
  - superior to 3x the average of other transactions from this user => **score += 5 points**
  - superior to 2x the average of other transactions from this user => **score += 2 points**


If the **score > 10**, the transaction recommendation is `denied`


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
- This example only show a really small sample of how the logic could be implemented but we could improve the logic and score calcul with more robust models or even AI.
- Some errors are handled (customer empty, transaction_id empty..) but some aren't. We should add some errors handlers to be sure the API request sent is correct.
- For now all the logic is put in the services object (Rails pattern), but should think about a better and cleaner architecture.
- More tests.


