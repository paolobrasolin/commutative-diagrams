Given(/^I have a "([^\"]*)" document$/) do |dialect|
  @document = TeXWorld::Document.new(dialect)
end

Given(/^I(?:'m| am) compiling with "([^\"]*)"$/) do |format|
  @compiler = TeXWorld::Compiler.new(format)
end

When(/^the body is$/) do |code|
  @document.body = code
end

When(/^I use the "([^\"]*)" package$/) do |name|
  @document.append_to_preamble("\\usepackage{#{name}}\n")
end

When(/^I use the "([^\"]*)" module$/) do |name|
  @document.append_to_preamble("\\usemodule[#{name}]\n")
end

# When(/^I use the "([^\"]*)" package with options:$/) do |name, options|
  # use_package_with_options(name, options)
# end

When(/^I use the "([^\"]*)" TikZ library$/) do |name|
  @document.append_to_preamble("\\usetikzlibrary{#{name}}\n")
end

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

After do |scenario|
  _stdout, _stderr, status = Open3.capture3(
    'dvipng', 'test.dvi', '-o', 'test.png', chdir: '.tex-test'
  )

  embed('.tex-test/test.png','image/png','WUTWUT')
end










