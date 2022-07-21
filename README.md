# RDO website

The RDO website is now updated via Gerrit and can be cloned with the following
command:
```
git clone https://review.rdoproject.org/r/rdo-website
```

Instructions for configuring your
environment can be found at https://www.rdoproject.org/documentation/onboarding/
You will not need to sign up for Bugzilla or install the rdopkg in order to
contribute to the website.


# Run your own copy from a container (recommended method)

**Note:** This procedure has been tested in a Fedora 35 system using podman container engine.
It should run in other recent OSs using docker.

1. Create your own container

```
$ podman build -t rdo-website .
```

2. Run the website using the local content. This container will run the middleman engine in the container
using the local website content so that you can edit ant check the resulting webpage. You need to mount
the data and source directory from the local git repo to the container:

```
$ podman run -v $PWD/source:/tmp/source:Z -v $PWD/data:/tmp/data:Z -p 4567:4567 --rm localhost/rdo-website
```

Now you can point your browser to http://localhost:4567/ and you'll see your local copy of the website. Note that you may need to refresh the page after
editing the content to visualize the changes.

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
