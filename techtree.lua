-- Factorio tech tree

require "utils"

FACTORIO_VERSION = '1.1.110'

-- Recipes to load
if FACTORIO_VERSION >= '1.0.0' then
	TECH_FILES = {
		'data/core/lualib/util.lua',
		'data/base/prototypes/technology.lua'
	}
else
	TECH_FILES = {
		"inserter.lua",
		"technology.lua",
	}

	for i,v in ipairs(RECIPE_FILES) do RECIPE_FILES[i] = "data/base/prototypes/technology/" .. v end
end

-- Which string translation sections to use (now always in base.cfg)
LANGUAGE_SECTIONS = {
    ["technology-name"] = true,
}


defines = dofile('./defines.lua')
load_data(TECH_FILES)
load_translations(LANGUAGE_SECTIONS)


-- Graphviz output
print('strict digraph factorio {')
-- Change rankdir to RL or BT or omit entirely to change direction of graph
print('layout=dot; rankdir=LR; color="#ffffff"; bgcolor="#002233"; ratio=auto; ranksep=2.0; nodesep=0.15;')
-- Node default attributes
node_default = {}
node_default.color = '"#a8a9a8"'
node_default.fontname = '"TitilliumWeb-SemiBold"'
node_default.fontcolor = '"#ffffff"'
node_default.shape = 'box'
node_default.style = 'filled'
print(string.format('node [%s]', VizAttr(node_default)))
-- Edge default attributes
edge_default = {}
edge_default.penwidth = 2
edge_default.color = '"#808080"'
edge_default.fontname = node_default.fontname
edge_default.fontcolor = node_default.fontcolor
print(string.format('edge [%s]', VizAttr(edge_default)))

for id, tech in pairs(data) do
    -- Define the technology node first
    if tech.name:match('.*-%d+$') then
        -- Multi-level technologies don't have separate string translations, so we have to extract the level and reassemble
        translation_name, level = tech.name:match('(.*)-(%d+)$')
        label_name = string.format("%s %d", T(translation_name), level)
    else
        label_name = T(tech.name)
    end
    attr = {}
    attr.label = HtmlLabel(label_name, GetIcon(tech))
    attr.tooltip = string.format('"%s\nenergy_required: %s"', tech.name, tech.energy_required or "nil") -- Put the untranslated name into the tooltip
    attr.fillcolor = '"#6d7235"'
    attr.color = attr.fillcolor
    attr.shape = "cds"
    print(string.format('"Tech: %s" [%s];', tech.name, VizAttr(attr)))
    
    if tech.prerequisites ~= nil then
        -- Make edges from each prerequisite to this technology
        print(string.format("  // Prerequisites"))
        for prereq_id, prereq in pairs(tech.prerequisites) do
            -- Prerequisite -> Tech edge
            attr = {}
            print(string.format('  "Tech: %s" -> "Tech: %s" [%s];', prereq, tech.name, VizAttr(attr)))
        end
    end
    
    if tech.effects ~= nil then
        -- Recipes unlocked by researching this tech
        print(string.format("  // Unlocks"))
        for effect_id, effect in pairs(tech.effects) do
            if effect.type == "unlock-recipe" then
                attr = {}
                print(string.format('//  "Tech: %s" -> "Recipe: %s" [%s];', tech.name, effect.recipe, VizAttr(attr)))
            else
                --io.stderr:write("Unknown effect.type: "..effect.type.."\n")
            end
        end
    end
    
end
print("}") -- Done!
