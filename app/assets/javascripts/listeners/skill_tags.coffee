class @SkillsTags extends @BasicTags
  @registerListener '.skills-tags'

  create: (input) =>
    text: input,
    value: JSON.stringify {
      name: input
      scope: @options.scope
    }
