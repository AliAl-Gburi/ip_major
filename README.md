# AuctionHouse.Umbrella
## Installation Instructions
---
### Prerequisites
* [Elixir 1.12 or later](https://elixir-lang.org/install.html)
* MySQL

To run this project, you need to have [Elixir 1.12 or later](https://elixir-lang.org/install.html) and MySQL installed on your machine.
By installing Elixir, you will also be installing Erlang since without it, Elixir code wouldn't have a virtual machine to run on.



### Project Requirements

* Create .env.dev file
* Add your environmental variables
* Download the necessary dependencies
* Create the database
* Start the project

##### Create .env.dev file
In the root directory of your project (same level as .gitignore and this readme file), create a **.env.dev** file (you can name it whatever you want, but .env.dev is an appropriate name given its purpose).

##### Add your environmental variables
The contents of the file should look something like this:
```
export DATABASE_URL=[url]
export DATABASE_USERNAME=[username]
export DATABASE_PASSWORD=[password]
```
##### Download the necessary dependencies

Can be done by running this command in your terminal:
```
mix deps.get
```
Your terminal's working directory should be the root of this project.

##### Create the database

That can be done by running the command:
```
source .env.dev && mix ecto.create
```
Your terminal's working directory should be the root of this project.

##### Start the project
Thats all you need. To start your project run this in your terminal:
```
source .env.dev && iex -S mix phx.server
```
The ***source .env.dev*** part is only necessary if you're running the project on a terminal session for the first time. Whenever you restart your terminal, you'll need to add the ***source .env.dev*** part to load the environmental variables. Otherwise, you can start your project by running ***iex -S mix phx.server***
