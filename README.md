# Intro.

This boilerplate repo. I've written to demostrate how to comibine coffee-script, babel, seneca and pm2 together in a single workflow.

This repo. is highly inspired by [ramanujan](https://github.com/senecajs/ramanujan).

## Usage

```
npm i
npm run watch
```

Open URL `http://localhost:8000/api/ping` in browser to see the result as following:

```
{"pong":true,"api":true,"time":1478184987421}
```

Now you could run pm2 in another terminal window to see the process list:

```
pm2 list
┌──────────────────┬────┬──────┬───────┬────────┬─────────┬────────┬─────────────┬──────────┐
│ App name         │ id │ mode │ pid   │ status │ restart │ uptime │ memory      │ watching │
├──────────────────┼────┼──────┼───────┼────────┼─────────┼────────┼─────────────┼──────────┤
│ services-base0   │ 0  │ fork │ 51572 │ online │ 1       │ 47h    │ 18.590 MB   │  enabled │
│ services-base1   │ 1  │ fork │ 51573 │ online │ 1       │ 47h    │ 19.457 MB   │  enabled │
│ services-repl    │ 2  │ fork │ 51574 │ online │ 1       │ 47h    │ 18.574 MB   │  enabled │
│ services-front   │ 3  │ fork │ 3025  │ online │ 2       │ 35h    │ 26.695 MB   │  enabled │
│ services-api     │ 4  │ fork │ 51779 │ online │ 31      │ 47h    │ 47.969 MB   │  enabled │
│ services-members │ 5  │ fork │ 52554 │ online │ 24      │ 47h    │ 18.336 MB   │  enabled │
└──────────────────┴────┴──────┴───────┴────────┴─────────┴────────┴─────────────┴──────────┘
```

Using `pm2 logs` to see the logs outputed by each microservice.

Any changes to the service codes will trigger the auto-compilation and the process will be started by pm2.