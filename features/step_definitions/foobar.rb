Given(/^I have a "([^\"]*)" document$/) do |dialect|
  @document = TeXWorld::Document.new(dialect)
end

Given(/^I(?:'m| am) compiling with "([^\"]*)"$/) do |format|
  @compiler = TeXWorld::Compiler.new(format)
end

When(/^I use the "([^\"]*)" module$/) do |name|
  # self.document.appenduse_module(name)
end

When(/^the body is$/) do |code|
  @document.body = code
end

# When(/^I use the "([^\"]*)" package$/) do |name|
  # @document.append_to_preamble("\\usepackage{#{name}}\n")
# end

# When(/^I use the "([^\"]*)" package with options:$/) do |name, options|
  # use_package_with_options(name, options)
# end

# When(/^I use the "([^\"]*)" TikZ library$/) do |name|
  # use_tikz_library(name)
# end

# When(/^I use the "([^\"]*)" TikZ library$/) do |name|
  # use_tikz_library(name)
# end

Then(/^compilation (succeeds|fails)$/) do |outcome|
  path = '.tex-test'
  filename = 'test.tex'
  FileUtils.mkdir_p path
  FileUtils.rm_f Dir.glob("#{path}/*")
  @document.write_to_file(path, filename)
  succeeded = @compiler.compile(path, filename)
  case outcome
  when 'succeeds'
    expect(succeeded).to be true
  when 'fails'
    expect(succeeded).to be false
  end
end
