require_relative '../kruskal/graph'
require_relative '../kruskal/node'
require_relative '../kruskal/edge'
require_relative '../kruskal/kruskal'
require_relative 'hallway'

module RoomsConnection

  def connect_rooms
    edge_hash = get_spanning_tree
    edge_hash.each_pair do |source_room_id, values|
      values.each do |target_room_id|
        @hallways << Hallway.new( self, @rooms[ source_room_id ], @rooms[ target_room_id ] )
      end
    end
  end

  private

  def get_spanning_tree

    graph = Graph.new
    nodes = []

    @rooms.each_index do |index|
      node = Node.new( "Room ##{index}" )
      nodes << node
      graph.add_node( node )
    end

    nodes.each do |node|
      nodes.each do |other_node|
        next if node == other_node

        node_room = @rooms[ get_room_id_from_name( node.name ) ]
        node_other_room = @rooms[ get_room_id_from_name( other_node.name ) ]

        distance = node_room.room_center.distance( node_other_room.room_center )

        graph.add_edge(node, other_node, distance )
      end
    end

    edges = Kruskal.new.compute_mst(graph)

    edge_hash = {}
    edges.each do |e|
      node_1_id = get_room_id_from_name( e.node1.name )
      node_2_id = get_room_id_from_name( e.node2.name )
      edge_hash[ node_1_id ] = [] unless edge_hash.has_key?( node_1_id )
      edge_hash[ node_1_id ] << node_2_id
    end

    # pp edge_hash
    edge_hash
  end

  def get_room_id_from_name( room_name )
    room_name[ 6 .. -1 ].to_i
  end

end