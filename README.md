# RDO website

To get started, just fork a copy of this repository, make your changes and create a pull request.

1. [Forking a github repository](https://help.github.com/articles/fork-a-repo/)
2. [Making changes](https://help.github.com/articles/editing-files-in-your-repository/)
3. [Pull Requests](https://help.github.com/articles/about-pull-requests/)

# Run your own copy

PLEASE NOTE: There is no requirement to run your own copy, the following is just a reference
for those who may wish to do so.

To get started, you need to have Ruby and Ruby Gems installed, as well
as "bundler".


## Initial setup
Clone this repository and run the `setup.sh` script located in the checked out repository directory.

The script will initialize and update the git submodules, install system dependencies, and run a
`bundle install`.

It is expected that you are on a YUM based system with `sudo` access.

```
cd website
./setup.sh
```

## Running a local server

1. Start a local Middleman server:

   `./run-server.sh`

   This will update your locally installed gems and start a Middleman
   development server.

2. Next, browse to <http://0.0.0.0:4567>

3. Edit!

   When you edit files (pages, layouts, CSS, etc.), the site will
   dynamically update in development mode. (There's no need to refresh
   the page, unless you get a Ruby error.)


## Customizing your site

The site can be easily customized by editing `data/site.yml`.


## Adding a Post

To add a post to the community blog use:

```
./create-post.rb "TITLE"
```


## Build your static site

After getting it how you want, you can build the static site by running:

> *NOTE*: On CentOS / RHEL 7 you will be presented with a warning that
> ImageMagick is less than the recommended 6.8.0.

`bundle exec middleman build`


## Deploying

### Setting up deployment

FIXME: Right now, please reference `<data/site.yml>`

### Actual deployment

After copying your public key to the remote server and configuring your
site in <data/site.yml>, deployment is one simple command:

```
bundle exec middleman deploy
```


### Add new features (parsers, etc.)

Simply add a new `gem 'some-gem-here'` line in the `Gemfile` and run
`bundle install`


## More info

For more information, please check the excellent
[Middleman documentation](https://middlemanapp.com/basics/install/).
