class @SkillsTags extends @BasicTags
  Listener.register @, '.skills-tags'

  create: (input) =>
    text: input,
    value: JSON.stringify {
      name: input
      scope: @options.scope
    }
