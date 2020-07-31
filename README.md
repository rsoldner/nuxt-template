# Extending this template
A docker image is available for use from docker hub: rsoldner/nuxt-template:1.0

## Simplest docker run for testing
```
docker run -it --rm --name nuxt-template-test -p 8080:3000 rsoldner/nuxt-template:1.0
```

## Adding your own code

### Dockerfile
This is the recommended way to extend the template image. Create a dockerfile that copies your code into the container to overwrite the template files.
```
FROM rsoldner/nuxt-template:1.0

# Use for npm configuration (e.g. registry=...)
COPY npmrc /root/.npmrc

# Add additional npm packages
COPY src/package.json /src/package.json
RUN npm install

COPY src/components /src/components
COPY src/layouts /src/layouts
COPY src/pages /src/pages
COPY src/nuxt.config.js /src/nuxt.config.js

RUN npm run build
CMD npm run start
```

### Volume maps for dev
The docker run command here shows using volume maps to override with your project code.
NOTE: if you map the /src directory, you will lose the node_modules
```
docker run \
    -it --rm \
    --name nuxt-template-test \
    -p 8080:3000 \
    -v ${PWD}/pages:/src/pages \
    -v ${PWD}/components:/src/components \
    rsoldner/nuxt-template:1.0
```

# Starting From Scratch
- Create a directory for the nuxt-template project with a src dir
```
mkdir nuxt-template && mkdir nuxt-template/src && cd nuxt-template
```
- Use a docker run command to install and create the project
```
docker run \
    -it --rm \
    --name nuxt-template-build \
    -v ${PWD}/src:/src \
    --network=bridge \
    -e HOST=0.0.0.0 \
    -p 8080:3000
    --entrypoint bash \
    node:current
```

- Run the following commands in the container:
```
npm install -g create-nuxt-app
npx create-nuxt-app .
```

- Answers used to the create-nuxt-app prompts:
```
create-nuxt-app v3.2.0
✨  Generating Nuxt.js project in .
? Project name: nuxt-template
? Programming language: JavaScript
? Package manager: Npm
? UI framework: None
? Nuxt.js modules: (Press <space> to select, <a> to toggle all, <i> to invert selection)
? Linting tools: (Press <space> to select, <a> to toggle all, <i> to invert selection)
? Testing framework: Jest
? Rendering mode: Universal (SSR / SSG)
? Deployment target: Server (Node.js hosting)
? Development tools: (Press <space> to select, <a> to toggle all, <i> to invert selection)
```

At this point, should be ready to test the install from your browser:
NOTE: the output from node will say listening on "172.17.0.2:3000". This is in the container, so the access from the host port 8080 must be used since that was our port mapping in the docker run command.
```
    http://localhost:8080/
```


Now that this directory is created, the npm install/create-nuxt-app commands do not need re-executed, as all the code lives within the directory.
Next step is to create a dockerfile that will add the files to the container so that a full volume map is not required
Run the following from the nuxt-template/ root

```
  touch npmrc
  docker build -t nuxt-template:dev .

  docker run -it --rm --name nuxt-template-no-vol-map -p 8080:3000 nuxt-template:dev
```

We now have a fully containerized nuxt template application
Extending this app can be done by volume mapping the specific directories in /src, or by writing a new dockerfile for your project to overwrite those directories.
