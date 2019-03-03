# Define a required runtime environment variable which would raise on missing.
macro runtime_env(*envs)
  {% for env in envs %}
    raise "Runtime environment variable {{env.id}} is not defined!" unless ENV.has_key?("{{env.id}}")
  {% end %}
end

# Define a required buildtime environment variable which would raise on missing.
macro buildtime_env(*env)
  {% for env in envs %}
    {% raise "Buildtime environment variable #{env.id} is not defined!" unless env("#{env.id}") %}
  {% end %}
end
