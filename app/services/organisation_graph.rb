class OrganisationGraph
  attr_accessor :nodes, :edges, :scope

  def initialize(scope, context: {})
    @scope = scope
    @context = context
    extract_nodes
    extract_edges
  end

  private

  def extract_nodes
    @nodes = @scope.all.decorate(context: @context).map(&:for_graph)
  end

  def extract_edges
    @edges ||= []
    scope.each do |node|
      next unless node.has_children?
      node.children.each do |child|
        @edges << {
          from: node.id,
          to: child.id
        }
      end
    end
  end
end
