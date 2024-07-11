local util = require("change_case.util")

local function assert_lists_equal(list1, list2)
  assert(#list1 == #list2, string.format("Lists are of different lengths %d ~= %d", #list1, #list2))
  for i = 1, #list1 do
    assert(list1[i] == list2[i], string.format("Lists differ at index %d: %s ~= %s", i, list1[i], list2[i]))
  end
end

describe("util.", function()
  for _, test in ipairs({
    { "camelCaseExample", { "camel", "Case", "Example" } },
    { "UpperCamelCaseExample", { "Upper", "Camel", "Case", "Example" } },
    { "snake_case_example", { "snake", "case", "example" } },
    { "kebab-case-example", { "kebab", "case", "example" } },
    { "SCREAM_SNAKE_CASE_EXAMPLE", { "SCREAM", "SNAKE", "CASE", "EXAMPLE" } },
    { "lowercaseexample", { "lowercaseexample" } },
    { "UPPERCASEEXAMPLE", { "UPPERCASEEXAMPLE" } },
    { "Train-Case-Example", { "Train", "Case", "Example" } },
    { "dot.case.example", { "dot", "case", "example" } },
    { "_isITDepartment-", { "is", "ITDepartment" } },
  }) do
    it("split_into_words(" .. test[1] .. ") == " .. vim.inspect(test[2]), function()
      local input = test[1]
      local expected = test[2]
      local actual = util.split_into_words(input)
      assert_lists_equal(actual, expected)
    end)
  end

  for _, test in ipairs({
    { { "allowed", "Commands" }, "scream_snake_case", "ALLOWED_COMMANDS" },
    { { "ALLOWED", "COMMANDS" }, "camel_case", "allowedCommands" },
  }) do
    it("words_to_case(" .. vim.inspect(test[1]) .. ", " .. test[2] .. ") == " .. vim.inspect(test[2]), function()
      local input = test[1]
      local case = test[2]
      local expected = test[3]
      local actual = util.words_to_case(input, case)
      assert(actual == expected, string.format("Actual: %s, Expected: %s", actual, expected))
    end)
  end
end)
