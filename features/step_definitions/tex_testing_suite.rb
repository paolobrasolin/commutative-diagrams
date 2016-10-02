Before do |scenario|
  @job = TeXWorld::Job.new
end

Given(/^I have a "([^\"]*)" document$/) do |dialect|
  @job.document.load_dialect(dialect)
end

Given(/^I(?:'m| am) compiling through "([^\"]*)"$/) do |pipeline|
  @job.pipeline.load(pipeline)
end

When(/^the body is$/) do |code|
  @job.document.content['body'] = code
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

After do |scenario|
  @job.pipeline.load('dvipng')
  @job.run
  embed(".tex-test/#{@job.jobname}.png", 'image/png', @job.jobname)
end
