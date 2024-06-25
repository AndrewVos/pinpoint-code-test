# README

## Setup

```
bundle install
```

Then, create a `.env` file that looks like:

```
PINPOINT_DOMAIN=
PINPOINT_API_KEY=
PINPOINT_APPLICATION_ID=
HIBOB_SERVICE_USER_ID=
HIBOB_SERVICE_USER_PASSWORD=
HIBOB_WORK_SITE=
```

Note that `PINPOINT_APPLICATION_ID` is only used for the end to end rake test.

## Specs

```
bundle exec rspec
```

## Testing the full end to end flow

```
rails webhooks:application_hired
```
