# Factorio Trees
This is a collection of Lua scripts that parse Factorio's data files and then use GraphViz to generate trees for recipe and technology dependencies. It does not add woody perennial plants to Factorio, sorry.

![Partial screenshot](screenshot.png "Example")


# Prerequisites
* Lua
* GraphViz

# Run
    git clone https://github.com/djsigmann/factorio-trees.git
    cd factorio-trees
    # replace with factorio's installation directory
    make FACTORIO_ROOT="${FACTORIO_ROOT}"
