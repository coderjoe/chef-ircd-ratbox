# ircd-ratbox cookbook

[![Build Status](https://travis-ci.org/coderjoe/chef-ircd-ratbox.svg?branch=master)](https://travis-ci.org/coderjoe/chef-ircd-ratbox)

A cookbook designed to build and install ircd-ratbox and ratbox-services from the official downloads.
Due to the complex nature of ircd configuration only the default configuration is installed.
Configuration of ircd is left as an exercise for any recipes using this cookbook.

## Supported Platforms

This cookbook has only tested under:
 - Ubuntu 12.04
 - Ubuntu 13.10
 - Ubuntu 14.04
 - Debian 7.4

It may work on other Unix like operating systems, but your mileage may differ.

## Attributes

| Key                                | Type    | Default                           | Description                                                          |
|------------------------------------|---------|-----------------------------------|----------------------------------------------------------------------|
| ['ircd']['user']                   | String  | "ircd"                            | The user to create that ircd will be installed as                    |
| ['ircd']['group']                  | String  | "ircd"                            | The group to be created that ircd will be installed as               |
| ['ircd']['server']['version']      | String  | "3.0.8"                           | The ircd-ratbox version to install                                   |
| ['ircd']['server']['directory']    | String  | "/usr/local/ircd/ratbox"          | The install directory "/usr/local/ircd"                              |
| ['ircd']['server']['sourcedir']    | String  | server directory + /src           | The source code directory                                            |
| ['ircd']['services']['version']    | String  | "1.2.4"                           | The ircd-ratbox version to install                                   |
| ['ircd']['services']['directory']  | String  | "/usr/local/ircd/ratbox-services" | The install directory "/usr/local/ircd"                              |
| ['ircd']['services']['sourcedir']  | String  | services directory + /src         | The source code directory                                            |

## Usage

### ircd-ratbox::default

Include `ircd-ratbox` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[ircd-ratbox::default]"
  ]
}
```

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: Joseph Bauser (coderjoe@coderjoe.net)
