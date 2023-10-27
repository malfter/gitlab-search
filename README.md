# GitLab Search ![CI Build Status](https://github.com/phillipj/gitlab-search/workflows/CI/badge.svg)

This is a command line tool that allows you to search for contents across all your GitLab repositories.
That's something GitLab doesn't provide out of the box for non-enterprise users, but is extremely valuable
when needed.

## Prerequisites

1. Install [Node.js](https://nodejs.org)
2. Create a [personal GitLab access token](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html#creating-a-personal-access-token) with the `read_api` scope.

## Installation

```bash
$ npm install -g gitlab-search
```

To finish the installation you need to configure the personal access token you've created previously:

```bash
$ gitlab-search setup <your personal access token>
```

That will create a `.gitlabsearchrc` file in the current directory. That configuration file can be placed
in different places on your machine, valid locations are described in the [rc package's README](https://www.npmjs.com/package/rc#standards).
You can decide where that file is saved when invoking the setup command, see more details in its help:

```bash
$ gitlab-search setup --help
```

## Usage

Searching through all the repositories you've got access to:

```bash
$ gitlab-search [options] [command] <search-term>

Options:
  -V, --version                            output the version number
  -g, --groups <group-names>               group(s) to find repositories in (separated with comma)
  -f, --filename <filename>                only search for contents in given a file, glob matching with wildcards (*)
  -e, --extension <file-extension>         only search for contents in files with given extension
  -p, --path <path>                        only search in files in the given path
  -a, --archive [all,only,exclude]         search only in archived projects, exclude archived projects, search in all projects (default is all)
  -h, --help                               output usage information

Commands:
  setup [options] <personal-access-token>  create configuration file
```

## Use with Self-Managed GitLab

To search a self-hosted installation of GitLab, `setup` has options for, among other things, setting a custom domain:

```bash
$ gitlab-search setup --help

Usage: setup [options] <personal-access-token>

create configuration file

Options:
  --ignore-ssl            ignore invalid SSL certificate from the GitLab API server
  --api-domain <name>     domain name or root URL of GitLab API server,
                          specify root URL (without trailing slash) to use HTTP instead of HTTPS (default: "gitlab.com")
  --dir <path>            path to directory to save configuration file in (default: ".")
  --concurrency <number>  limit the amount of concurrent HTTPS requests sent to GitLab when searching,
                          useful when *many* projects are hosted on a small GitLab instance
                          to avoid overwhelming the instance resulting in 502 errors (default: 25)
  -h, --help              display help for command
```

## Use as Container Image

If you don't want to install Node on your local System to build `gitlab-search`, you can also use a Container Image.

```bash
docker build --tag gitlab-search:v1.5.0 .
```

Here is an example of how you can use `gitlab-search` using a zsh function:

```bash
function gitlab-search() {
  # Ensure files exist to avoid being created by Docker and thus owned by root:
  touch "${HOME}"/.gitlabsearchrc
  docker run \
    --interactive \
    --rm \
    --tty \
    --volume="${HOME}/.gitlabsearchrc:${HOME}/.gitlabsearchrc:rw" \
    --volume="/run/user/$(id -u):/run/user/$(id -u):ro" \
    --workdir="${PWD}" \
    gitlab-search:1.5.0 $@
}
```

## Debugging

If something seems fishy or you're just curious what `gitlab-search` does under the hood, enabling debug logging helps:

```bash
$ DEBUG=1 gitlab-search here-is-my-search-term
Requesting: GET https://gitlab.com/api/v4/groups?per_page=100
Using groups: name-of-group1, name-of-group2
Requesting: GET https://gitlab.com/api/v4/groups/42/projects?per_page=100
Requesting: GET https://gitlab.com/api/v4/groups/1337/projects?per_page=100
Using projects: hello-world, my-awesome-website.com
Requesting: GET https://gitlab.com/api/v4/projects/666/search?scope=blobs&search=here-is-my-search-term
Requesting: GET https://gitlab.com/api/v4/projects/999/search?scope=blobs&search=here-is-my-search-term
```

## License

MIT
