# ircd-ratbox cookbook

[![Build Status](https://travis-ci.org/coderjoe/chef-ircd-ratbox.svg?branch=master)](https://travis-ci.org/coderjoe/chef-ircd-ratbox)
[![Dependency Status](https://gemnasium.com/coderjoe/chef-ircd-ratbox.svg)](https://gemnasium.com/coderjoe/chef-ircd-ratbox)

A cookbook designed to build and install ircd-ratbox and ratbox-services from the official downloads.
Due to the complex nature of ircd configuration only the default configuration is installed.
Configuration of ircd is left as an exercise for any recipes using this cookbook.

## Supported Platforms

This cookbook has only tested under:
 - Ubuntu 12.04
 - Debian 7.4

It may work on other Unix like operating systems, but your mileage may differ.

## Attributes

| Key                                | Type    | Default                           | Description                                                          |
|------------------------------------|---------|-----------------------------------|----------------------------------------------------------------------|
| ['ircd']['server']['user']         | String  | "ratbox"                          | The user to create that ircd will be installed as                    |
| ['ircd']['server']['group']        | String  | "ratbox"                          | The group to be created that ircd will be installed as               |
| ['ircd']['server']['directory']    | String  | "/home/ratbox"                    | The install directory "/usr/local/ircd"                              |
| ['ircd']['server']['download']     | String  | ratbox version 3.0.8              | The URI to the ratbox download archive to build and install          |
| ['ircd']['server']['sourcedir']    | String  | server directory + /src           | The source code directory                                            |
| ['ircd']['services']['user']       | String  | "ratbox-services"                 | The user to create that ratbox services will be installed as         |
| ['ircd']['services']['group']      | String  | "ratbox-services"                 | The group to be created that ratbox services will be installed as    |
| ['ircd']['services']['directory']  | String  | "/home/ratbox-services"           | The install directory "/usr/local/ircd"                              |
| ['ircd']['services']['download']   | String  | ratbox-services version 1.2.4     | The URI to the ratbox-services download archive to build and install |
| ['ircd']['services']['sourcedir']  | String  | services directory + /src         | The source code directory                                            |

## Usage

If you'd like to install both ratbox and ratbox-services you can use the default recipe.

Include `ircd-ratbox` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[ircd-ratbox::default]"
  ]
}
```

Otherwise you can choose between installing either the ratbox ircd server or ratbox-services
using their individual recipes.

```json
{
  "run_list": [
    "recipe[ircd-ratbox::server]",
    "recipe[ircd-ratbox::services]"
  ]
}
```

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write you change
4. Write tests for your change
5. Run the tests, ensuring they all pass in both ruby 1.9.3 and 2.0.0
6. Submit a Pull Request

## License and Authors

Author:: Joseph Bauser (coderjoe@coderjoe.net)
