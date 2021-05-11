<img src="https://raw.githubusercontent.com/fullstacklabs/toy-blocks/master/FSL-logo-portrait.png" alt="FullStack Labs" align="center" />

<br />

# Cuboids

## Challenge

This API manages bags and cuboids. A cuboid is a three-dimensional rectangular box. Each face of a cuboid is a
rectangle and adjacent faces meet at right angles. A cube is a cuboid with equal dimensions. A cuboid has a
volume that is straightforward to calculate.

A bag is a malleable container with adjustable dimensions, but a fixed volume. The bag can expand to hold any
shape or combination of shapes, but the volume of the bag is limited and cannot expand. In our model a bag
has many cuboids.

This app has an almost complete test suite.

The tests to update and delete a cuboid are incomplete, your task is to improve them.

The other tests are valid and you must not modify them. In other words, you need to add the missing functionalities so that these tests pass.

Take note of the formatter (`mix format`) and static analysis tooling (`mix credo`). These tools should pass upon on completion
of the challenge without any changes to project configuration.

**Note**: The only tests to be modified are tests to update and delete a cuboid. All other tests must remain unchanged.

### Steps

To participate in this challenge take the following steps:

1. Clone this repository.
2. Create a private repository of the same name in your personal GitHub account. (Do not fork)
3. Add a second remote to your local copy of this repository and push the master branch.
4. Checkout a feature branch where you will make your changes.
5. Setup the app and get it running. Verify that the linter passes and the test suite fails.
6. Implement tests to update and delete a cuboid.
7. Add missing functionalities so the other tests pass. Do NOT modify these tests.
8. Commit as appropriate as you complete the challenge. (More than one commit is expected)
9. Push your committed changes to your repository on your feature branch.
10. Create a pull request to the master branch on your repository.
11. Invite @bencarle and @mfpiccolo to your private repository.
12. Send the link to your pull request to signify the completion of the challenge.

## Technology

This app uses the following key technologies:

- [Phoenix](https://www.phoenixframework.org/)
- [Ecto](https://hexdocs.pm/phoenix/ecto.html)
- [Mix](https://hexdocs.pm/mix/Mix.html)
- [Docker Compose](https://docs.docker.com/compose/)


## Setup

1. Install dependencies.
```shell
mix deps.get
```

2. Use `docker-compose` to start the PostgreSQL database, or look inside `config/dev.exs` for database configuration requirements.
```shell
docker-compose
```

3. Create and migrate your database.
```shell
mix ecto.setup
```
## Usage

Run the app.
```shell
mix phx.server
```

Run the linter.
```shell
mix format
```

Run the tests.
```shell
mix test
```

Run static analysis.
```shell
mix credo
```