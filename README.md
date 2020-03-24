# node-boilerplate
Basic dockerized boilerplate to start working with Node.js

## Development

### Setups

#### Local development

To ease your experience, use the [Node Version Manager for UNIX](https://github.com/nvm-sh/nvm)
or the [Node Version Manager for Windows](https://github.com/coreybutler/nvm-windows).

1. Install the necessary versions of node & npm on your machine as defined in `package.json:engines.node`
  ```sh
  $ nvm use <version>
  $ nvm install-latest-npm # nvm unix only
  ```
2. Install the necessary dependencies
  ```sh
  $ npm i
  ```
3. Start the app in development:
  ```sh
  $ npm run dev
  ```

The `dev` script uses `nodemon` under the hood to listen for file changes.
Any changes to source files in `./src` will result in the process to restart. Likewise
any install to `package.json` will restart the process.

##### Local development with debug port open

TODO: This feature is currently unimplemented.

#### docker-compose

1. Install `docker` & `docker-compose`
2. Create a `.env.development.local` file.
3. Start the docker-compose setup in development:
  ```sh
  $ DOCKER_ENV=development docker-compose up -d
  $ DOCKER_ENV=development docker-compose logs --follow
  ```

For now, unlike the local development, the docker-compose setup uses the `start` script, which does not use `nodemon`. Consequently, **your code will not hot reload, and you will need to compose down and rebuild the compose when going up.**

```sh
DOCKER_ENV=development docker-compose down
DOCKER_ENV=development docker-compose up --build -d
```

##### Exposing ports

The current `docker-compose.yml` configuration exposes the ports `8080` and `4433` for HTTP and HTTPS respectively.

##### Containerized development with debug port open

TODO: This feature is currently unimplemented. Implement Local development with debug port open first.

## Environment variables

This boilerplate is setup to load env_files locally and in the docker-compose setup, but not in the
bare docker setup.

For all setups, the `start*` and `dev` scripts run `./scripts/withEnv.js` to filter the environment
to avoid exposing secrets and environment from other processes.
The filter for the variable can be specified as a regular expression as an environment variable as `ENV_FILTER_PREFIX_REGEX` and defaults to `/^NODE_BOILERPLATE_/i`. Hence, all of your custom environment
variables must match the resolved value of `ENV_FILTER_PREFIX_REGEX`.

This feature was extracted from [create-react-app](https://create-react-app.dev/docs/adding-custom-environment-variables/).

### Setups

#### Local

Running `start:*` and `dev` scripts will load the environment variables from the following files:

```
.env
.env.${NODE_ENV}
.env.${NODE_ENV}.local
```

which are all optional.

Like with create-react-app, each each of the env file above override each other in order of specificity.
Both the `.env` and `.env.${NODE_ENV}` files are committed to source version control, while 
`.env.${NODE_ENV}.local` is a local override and is not committed to source version control. That
makes it a prime place to store your secret environment variables.

#### docker-compose

The docker-compose setup works exactly the same as the local setup, with the exception that you must
have all three environment files specified above present on the file system.

#### docker

TODO: The docker setup does not load environment from .env files, as the author is not sure what are
the best practices to implement environment variables for docker image deployment to registry.
If you wish to run the docker setup in production locally, use 
`DOCKER_ENV=production docker-compose up`.

## JSON keys

TODO: This repository currently does not automatically load JSON keys.

## Testing

Testing is done using [jest](https://jestjs.io/).
Currently testing can only be done locally, so you'll need to go through the
installation of local dependencies (node, npm, packages).

All files matching the glob `src/**/*.{itest,test}.js` will be run as tests.

* `*.test.js` files are for unit tests
* `*.itest.js` files are for integration tests

To run your tests, simply run

```sh
$ npm run test
```

### Testing with debug port open

You can test with the debug port open using the `test:debug` script.

### End-to-end tests

TODO: End-to-end testing is not implemented in this boilerplate.

## Continuous Integration (CI)

This boilerplate is setup with pre-commit hooks that tests and fixes formatting issues using
`jest` and `lint-staged`.

Moreover, this boilerplate is setup with [cz-conventional-changelog](https://www.npmjs.com/package/cz-conventional-changelog) if you wish to use [commitizen](https://www.npmjs.com/package/commitizen) for your commit messages.

## Running in production

### Setups

#### Local

```sh
$ npm run start:prod
```

#### With docker-compose

```sh
$ DOCKER_ENV=production docker-compose up
```

#### Docker

```sh
$ docker build -t node_boilerplate:1.0 .
$ docker container run --name node_boilerplate_server node_boilerplate:1.0
```

### Deploying to your own registry

Currently the Dockerfile exposes a multi-stage image that can be prebuilt and then
deployed to the registry with minimal overhead.
This boilerplate has not been set up with a deployment method however.

TODO: This section needs to be expanded and completed.

### Healthcheck

TODO: Healthcheck has not been implemented yet in this boilerplate.

## Javascript Features

Make sure to go see `.babelrc` as well as the Node.js runtime for the specified
engine version to go see what language features are enabled!