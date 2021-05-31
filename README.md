# 🍍 AbbrevMan.nvim

<p align="center">
	A NeoVim plugin that manages abbreviations for various natural and programming languages!
</p>

<p align="center">
    <a href="https://github.com/Pocco81/AbbrevMan.nvim/stargazers"
        ><img
            src="https://img.shields.io/github/stars/Pocco81/AbbrevMan.nvim"
            alt="Repository's starts"
    /></a>
    <a href="https://github.com/Pocco81/AbbrevMan.nvim/issues"
        ><img
            src="https://img.shields.io/github/issues-raw/Pocco81/AbbrevMan.nvim"
            alt="Issues"
    /></a>
    <a href="https://github.com/Pocco81/AbbrevMan.nvim/blob/main/LICENSE"
        ><img
            src="https://img.shields.io/github/license/Pocco81/AbbrevMan.nvim"
            alt="License"
    /><br />
    <a href="https://saythanks.io/to/Pocco81%40gmail.com"
        ><img
            src="https://img.shields.io/badge/say-thanks-modal.svg"
            alt="Say thanks"/></a
    ></a>    <a href="https://github.com/Pocco81/whid.nvim/commits/main"
    <a href="https://github.com/Pocco81/AbbrevMan.nvim/commits/main"
		><img
			src="https://img.shields.io/github/last-commit/Pocco81/AbbrevMan.nvim/dev"
			alt="Latest commit"
    /></a>
    <a href="https://github.com/Pocco81/AbbrevMan.nvim"
        ><img
            src="https://img.shields.io/github/repo-size/Pocco81/AbbrevMan.nvim"
            alt="GitHub repository size"
    /></a>
</p>


<kbd><img src ="https://i.imgur.com/bKUJPcB.gif"></kbd>
<p align="center">
	Demo
</p><hr>


# TL;DR

<div style="text-align: justify">
	AbbrevMan.nvim is a NeoVim plugin written in lua that ehances (n)vim's built-in abbreviations (`:h iab`) by giving users the possibility to manage different "dictionaries" for various natural (e.g. English, Spanish) and programming (e.g. Bash, Lua) languages; the idea is that the users will create their own dictionaries, however there are also some built-in ones that are worth checking out. It can be installed using your package manager of preference and it will work out of the box (the English dictionary enabled by default).
</div>



# 🌲 Table of Contents

* [Features](#-features)
* [Notices](#-notices)
* [Installation](#-installation)
	* [Prerequisites](#prerequisites)
	* [Adding the plugin](#adding-the-plugin)
	* [Setup Configuration](#setup-configuration)
		* [For init.lua](#for-initlua)
		* [For init.vim](#for-initvim)
	* [Updating](#updating)
* [Usage (commands)](#-usage-commands)
	* [Default](#default)
* [Configuration](#-configuration)
	* [General](#general)
	* [Highlight Colors](#highlight-colors)
* [Key Bindings](#-key-bindings)
* [Contribute](#-contribute)
* [Inspirations](#-inspirations)
* [License](#-license)
* [FAQ](#-faq)
* [To-Do](#-to-do)

# 🎁 Features
- Users can create custom dictionaries.
- Users can override and delete elements in the built-in dictionaries.
- Has commands to load and unload dictionaries at any given time.
- Can be set to load or not at startup.
- Tab auto-completion for the commands.


# 📺 Notices
Checkout the [CHANGELOG.md](https://github.com/Pocco81/AbbrevMan.nvim/blob/main/CHANGELOG.md) file for more information on the notices below:

# 📦 Installation

## Prerequisites

- [NeoVim nightly](https://github.com/neovim/neovim/releases/tag/nightly) (>=v0.5.0)

## Adding the plugin
You can use your favorite plugin manager for this. Here are some examples with the most popular ones:

### Vim-plug

```lua
Plug 'Pocco81/AbbrevMan.nvim'
```
### Packer.nvim

```lua
use "Pocco81/AbbrevMan.nvim"
```

### Vundle

```lua
Plugin 'Pocco81/AbbrevMan.nvim'
```

### NeoBundle
```lua
NeoBundleFetch 'Pocco81/AbbrevMan.nvim'
```

## Setup (configuration)
As it's stated in the TL;DR, there are already some sane defaults that you may like, however you can change them to match your taste. These are the defaults:
```lua
load_natural_dictionaries_at_startup = true,
load_programming_dictionaries_at_startup = true,
natural_dictionaries = {
	["nt_en"] = {}
},
programming_dictionaries = {
	["pr_py"] = {}
}
```

The way you setup the settings on your config varies on whether you are using vimscript for this or Lua.


<details>
    <summary>For init.lua</summary>
<p>

```lua
local abbrev_man = require("abbrev-man")

abbrev_man.setup({
	load_natural_dictionaries_at_startup = true,
	load_programming_dictionaries_at_startup = true,
	natural_dictionaries = {
		["nt_en"] = {}
	},
	programming_dictionaries = {
		["pr_py"] = {}
	}

})
```
<br />
</details>


<details>
    <summary>For init.vim</summary>
<p>

```lua
lua << EOF
local abbrev_man = require("abbrev-man")

abbrev_man.setup({
	load_natural_dictionaries_at_startup = true,
	load_programming_dictionaries_at_startup = true,
	natural_dictionaries = {
		["nt_en"] = {}
	},
	programming_dictionaries = {
		["pr_py"] = {}
	}

})
EOF
```
<br />
</details>

For instructions on how to configure the plugin, check out the [configuration](#configuration) section.

## Updating
This depends on your plugin manager. If, for example, you are using Packer.nvim, you can update it with this command:
```lua
:PackerUpdate
```

# 🤖 Usage (commands)
All the commands follow the *camel casing* naming convention and have the `AM` (**A**bbreviation **M**anager) prefix so that it's easy to remember that they are part of the AbbrevMan.nvim plugin. These are all of them:

## Default
- `:AMLoad <dictionary>` Loads a dictionary. If `<dictionary>` hasn't been loaded, it will load it, otherwise it will show a message explaining the error.
- `:AMUnload <dictionary>` Unloads a dictionary. If `<dictionary>` has been loaded, it will unload it, otherwise it will show a message explaining the error.

# 🐬 Configuration
Although the settings already have self-explanatory names, here is where you can find info about each one of them and their classifications! 

## General
These settings are unrelated to any group and are independent.
- `load_natural_dictionaries_at_startup`: (Boolean) if true, it will load the dictionaries in the `natural_dictionaries` table at startup.
- `load_programming_dictionaries_at_startup`: (Boolean) if true, it will load the dictionaries in the `programming_dictionaries` tables at startup.

## Dictionaries
The following tables contain the dictionaries that you want to be enabled (either at startup or by loading them with `:AMLoad <dictionary>`). Although each table has its own "rules" (mentioned below), this is the general syntax that a dictionary must have:

```
["<prefix><name>"] = {
	["<abbreviation>"] = "<element>"
}
```

- `<prefix>`: represents the group  the dictionary belongs to. It can either be `nt_` (if you put it in the `natural_dictionaries` tables) or `pr_` (if you put it in the `programming_dictionaries` table).
- `<name>`: the name you'd like to give to your dictionary.
- `<abbreviation>`: the abbreviation itself.
- `<element>`: what the abbreviation means (aka what will be put after you press space after the typing the abbreviation.)

Here is an example:

```
natural_dictionaries = {
	["nt_en"] = {
		["adn"] = "AND",
		["THe"] = "rm_am"
	},
	["nt_my_slangs"] {
		["lmao"] = "LMAO"
	}
},
programming_dictionaries = {
	["pr_py"] = {}
}
```

In this example, we are enabling the `Python` dictionary in the `programming_dictionaries = {}` table and we are enabling the English dictionary (`nt_en`) and custom one for slangs (`nt_my_slangs`) in the `natural_dictionaries = {}` table. In the English table we override the value of the **adn** (`["adn"]`), which is the auto-correction for mistyping the word **and**, and set it to auto-correct to **AND**. Here, we are also removing the value of **THe** from the auto-correction's list by setting it to `"rm_am"`. Of course, it also added out custom dictionary (`["nt_my_slangs"]`).

AbbrevMan.nvim **is not meant to be an spell checker or an auto-correction engine**, it simply has some built-in in dictionaries that can be used for that purpose too. Again, that's not AbbrevMan's main purpose, but if you want to use it like that, feel free to do so.

### Natural and Programming Dictionaries
- **Natural Dictionaries:** The table `natural_dictionaries = {}` contains all the dictionaries for the various natural languages (e.g. English). The name of each dictionary **must** start with the prefix `nt_`, followed by the name of that dictionary.
- **Programming Dictionaries:** The table `programming_dictionaries = {}` contains all the dictionaries for the various programming languages (e.g. JavaScript). The name of each dictionary **must** start with the prefix `pr_`, followed by the extension that a file written in that language has (e.g for **Python** files the extension is `.py`, so we put `py` here).

#### Supported Languages

These are the lists with all the currently supported languages (remember that the idea is for you to add your own):

Note: In the `State` column, `working` means that the dictionary has something and it's supported, while `Supported` means that AbbrevMan.nvim supports the dictionary but is under development, so it's better not to use it.

##### Natural Languages

| Nat. Language | Dict. Name | State     |
|---------------|------------|-----------|
| English       | `nt_en`    | Working   |
| Spanish       | `nt_es`    | Supported |
| Portuguese    | `nt_pt`    | Supported |
| Polish        | `nt_pl`    | Working   |

##### Programming Languages

| Pro. Language | Dict. Name | State     |
|---------------|------------|-----------|
| Python        | `pr_py`    | Supported |
| Java          | `pr_java`  | Supported |
| Lua           | `pr_lua`   | Supported |

# 🧻 Key-bindings
There are no default key-bindings. However, you can set them on your own as you'd normally do! Here is an example mapping `<F3>` to load the English dictionary while on normal:

**For init.lua**
```lua
vim.api.nvim_set_keymap(
    "n",
    "<F3>",
    "AMLoad nt_en<CR>",
    {
        noremap = true,
        silent = true
    }
)
```

**For init.vim**
```vimscript
nnoremap <silent> <f3> :AMLoad nt_en<CR>
```

# 🙋 FAQ

- Q: ***"How can I view the doc from NeoVim?"***
- A: Use `:help abbrev-man`


# 🫂 Contribute

Pull Requests are welcomed as long as they are properly justified and there are no conflicts. If your PR has something to do with the README or in general related with the documentation, I'll gladly merge it! Also, when writing code for the project **you must** use the [.editorconfig](https://github.com/Pocco81/AbbrevMan.nvim/blob/main/.editorconfig) file on your editor so as to "maintain consistent coding styles". For instructions on how to use this file refer to [EditorConfig's website](https://editorconfig.org/).

Things I currently need help on:

- Creating dictionaries for natural languages. Use the [English dictionary](https://github.com/Pocco81/AbbrevMan.nvim/blob/dev/lua/abbrev-man/dictionaries/langs_natural/nt_en.lua) as a guide.
- Creating dictionaries for programming languages. Use the [Python dictionary](https://github.com/Pocco81/AbbrevMan.nvim/blob/dev/lua/abbrev-man/dictionaries/langs_programming/pr_py.lua) as a guide.


# 💭 Inspirations

The following projects inspired the creation of AbbrevMan.nvim. If possible, go check them out to see why they are so amazing :]
- [preservim/vim-litecorrect](https://github.com/preservim/vim-litecorrect): Lightweight auto-correction for Vim.

# 📜 License

AbbrevMan.nvim is released under the GPL v3.0 license. It grants open-source permissions for users including:

- The right to download and run the software freely
- The right to make changes to the software as desired
- The right to redistribute copies of the software
- The right to modify and distribute copies of new versions of the software

For more convoluted language, see the [LICENSE file](https://github.com/Pocco81/AbbrevMan.nvim/blob/main/LICENSE.md).

# 📋 TO-DO

**High Priority**
- Add more dictionaries!

**Low Priority**
- Refactor most of the code responsible for loading the dictionaries.

<hr>
<p align="center">
	Enjoy!
</p>

