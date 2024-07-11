--- @param text string
local capitalize = function(text)
  return string.upper(string.sub(text, 1, 1)) .. string.sub(text, 2)
end

--- @alias Case "camel_case" | "upper_camel_case" | "snake_case" | "kebab_case" | "scream_snake_case" | "lowercase" | "uppercase"

--- @class CaseTransformer
--- @field separator string
--- @field word_transformer fun(word: string, index: integer): string

--- @type table<Case, CaseTransformer>
return {
  camel_case = {
    separator = "",
    word_transformer = function(word, index)
      if index ~= 1 then
        return capitalize(word:lower())
      end
      return word:lower()
    end,
  },
  upper_camel_case = {
    separator = "",
    word_transformer = function(word)
      return capitalize(word)
    end,
  },
  snake_case = {
    separator = "_",
    word_transformer = function(word)
      return word:lower()
    end,
  },
  kebab_case = {
    separator = "-",
    word_transformer = function(word)
      return word:lower()
    end,
  },
  lowercase = {
    separator = "",
    word_transformer = function(word)
      return word:lower()
    end,
  },
  uppercase = {
    separator = "",
    word_transformer = function(word)
      return word:upper()
    end,
  },
  scream_snake_case = {
    separator = "_",
    word_transformer = function(word)
      return word:upper()
    end,
  },
  train_case = {
    separator = "-",
    word_transformer = function(word)
      return capitalize(word)
    end,
  },
  dot_case = {
    separator = ".",
    word_transformer = function(word)
      return word:lower()
    end,
  },
}
