class Listeners.SkillsTags extends Listeners.BasicTags
  @listenerSelector: '.skills-tags'

  create: (input) =>
    text: input,
    value: JSON.stringify {
      name: input
      scope: @options.scope
    }
