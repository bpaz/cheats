---
title: Sao.js
category: Javascript
layout: 2017/sheet
updated: 2018-10-28
description: ""
intro: >
    SAO helps you kick start new projects, real quick.
    Like Yeoman, we provide you a generator ecosystem. A generator is basically a starter, optionally you can add a saofile.js to control how to generate a new project.
---

### Install

```
yarn global add sao@next
sao -v
```

### Using a generator

```
sao nm my-project
```

A generator could be either:

* Local directory, e.g. sao ./path/to/my-generator
* An npm package, e.g. sao react will be package sao-react.
* To use an npm package that does not follow the sao-* naming convention, just prefix the name like this: sao npm:foo, then it will use the foo package instead of sao-foo.
* A git repository, e.g. sao egoist/sao-nm will use github.com/egoist/sao-nm


### Creating a generator

```
mkdir sample-generator
cd sample-generator
vim saofile.js
```

### Running a generator

```
sao ./sample-generator new-project
```

### Saofile Example
{: .-one-column}

```js
module.exports = {
  prompts: [
    {
      name: 'name',
      message: 'What is the name of the new project',
      default: '[folderName]'
    },
    {
      name: 'author',
      message: 'What is your name',
      default: '[gitUser]',
      store: true
    },
    {
      name: 'username',
      message: 'What is your GitHub username',
      default: '[gitUser]',
      store: true
    },
    {
      name: 'email',
      message: 'What is your GitHub email',
      default: '[gitEmail]',
      store: true,
      validate: v => /.+@.+/.test(v)
    },
    {
      name: 'website',
      message: 'What is the url of your website',
      default(answers) {
        return `https://github.com/${answers.username}`
      },
      store: true
    },
    {
      name: 'pm',
      message: 'Choose a package manager',
      choices: ['npm', 'yarn'],
      type: 'list',
      default: 'yarn'
    },
    {
      name: 'unitTest',
      message: 'Do you need unit test?',
      type: 'confirm',
      default: false
    },
    {
      name: 'coverage',
      message: 'Do you want to add test coverage support?',
      type: 'confirm',
      default: false,
      when: answers => answers.unitTest
    }
  ],
  actions: [
    {
      type: 'add',
      files: '**',
      filters: {
        'test/**': 'unitTest',
        'src/**': 'compile',
        'index.js': '!compile',
        'cli.js': 'cli',
        'circle-npm5.yml': 'pm === "npm5"',
        'circle-yarn.yml': 'pm === "yarn"',
        'example/**': 'poi'
      },
      transformerOptions: {
        context: {
          camelcase
        }
      }
    },
    {
      type: 'move',
      patterns: {
        // We keep `.gitignore` as `gitignore` in the project
        // Because when it's published to npm
        // `.gitignore` file will be ignored!
        gitignore: '.gitignore',
        'circle-*.yml': 'circle.yml'
      }
    }
  ],
  async completed() {
    await this.gitInit()
    await this.npmInstall({ packageManager: this.answers.pm })
    this.showCompleteTips()
  }
}
```


## References
{: .-one-column}

* <https://sao.js.org/#/>
* <https://github.com/saojs/sao/tree/next/docs/guide>
* <https://github.com/saojs/sao-nm>