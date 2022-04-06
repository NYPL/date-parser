# DateParser

A simple lambda wrapping [Timetwister](https://github.com/alexduryee/timetwister). This makes Timetwister's advanced date-parsing available to all library services.

## Using DateParser

DateParser expects events in the form 
```
{
  "path": "/",
  "body": "{\"dates\":[\"Jun 1898 - [July 4 1900],Jun 1898 - [July 4 1901]\"]}"
}
```

where `dates` can be any array of date strings.

## Requirements

- ruby 2.7

## Environment Variables

- LOG_LEVEL: the standard NYPL log levels, `debug`, `info`, etc.

## Contributing

1. Cut PRs from `main`
2. Merge into `main`
3. Merge into `qa` and `production` to deploy (TODO)


## Testing

Invoke tests with `bundle exec rspec`
