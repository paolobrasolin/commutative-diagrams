Before do |scenario|
  @job = TeXWorld::Job.new
  FileUtils.mkdir_p '.tex-test'
end

Given(/^I have a "([^\"]*)" document$/) do |dialect|
  @job.document.load_dialect(dialect)
end

Given(/^I(?:'m| am) compiling through "([^\"]*)"$/) do |pipeline|
  @job.pipeline.load(pipeline)
end

When(/^the preamble is$/) do |code|
  @job.document.content['preamble'] = code + "\n"
end

When(/^the body is$/) do |code|
  @job.document.content['body'] = code
end

When(/^I input the "([^\"]*)" file$/) do |name|
  @job.document.append_to_preamble("\\input #{name}\n")
end

When(/^I use the "([^\"]*)" package$/) do |name|
  @job.document.append_to_preamble("\\usepackage{#{name}}\n")
end

When(/^I use the "([^\"]*)" module$/) do |name|
  @job.document.append_to_preamble("\\usemodule[#{name}]\n")
end

# When(/^I use the "([^\"]*)" package with options:$/) do |name, options|
  # use_package_with_options(name, options)
# end

When(/^I use the "([^\"]*)" TikZ library$/) do |name|
  @job.document.append_to_preamble("\\usetikzlibrary{#{name}}\n")
end

When(/^I(?:'m| am) inside a "([^\"]*)" environment$/) do |name|
  @job.document.wrap_body("\\begin{#{name}}", "\\end{#{name}}")
end

Then(/^compilation (succeeds|fails)$/) do |outcome|
  # FileUtils.rm_f Dir.glob("#{path}/*")
  succeeded = @job.run
  case outcome
  when 'succeeds'
    expect(succeeded).to be true
  when 'fails'
    expect(succeeded).to be false
  end
end

Then(/^I want a screenshot$/) do
  # @job.pipeline.load('dvipng') if File.file?(".tex-test/#{@job.jobname}.dvi")
  # @job.pipeline.load('pdfpng') if File.file?(".tex-test/#{@job.jobname}.pdf")
  # @job.run
  # embed(".tex-test/#{@job.jobname}.png", 'image/png', @job.jobname)
end

After do |scenario|
end
