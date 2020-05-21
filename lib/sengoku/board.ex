defmodule Sengoku.Board do
  @moduledoc """
  Holds any and all board-specific data on the server.
  """

  defstruct [:players_count, :regions, :tiles, :name]

  alias Sengoku.{Region, Tile}

  @all_neighbor_ids %{
    1 => [2, 12, 13],
    2 => [1, 3, 13, 14],
    3 => [2, 4, 14, 15],
    4 => [3, 5, 15, 16],
    5 => [4, 6, 16, 17],
    6 => [5, 7, 17, 18],
    7 => [6, 8, 18, 19],
    8 => [7, 9, 19, 20],
    9 => [8, 10, 20, 21],
    10 => [9, 11, 21, 22],
    11 => [10, 22, 23],
    12 => [1, 13, 24],
    13 => [1, 2, 12, 14, 24, 25],
    14 => [2, 3, 13, 15, 25, 26],
    15 => [3, 4, 14, 16, 26, 27],
    16 => [4, 5, 15, 17, 27, 28],
    17 => [5, 6, 16, 18, 28, 29],
    18 => [6, 7, 17, 19, 29, 30],
    19 => [7, 8, 18, 20, 30, 31],
    20 => [8, 9, 19, 21, 31, 32],
    21 => [9, 10, 20, 22, 32, 33],
    22 => [10, 11, 21, 23, 33, 34],
    23 => [11, 22, 34],
    24 => [12, 13, 25, 35, 36],
    25 => [13, 14, 24, 26, 36, 37],
    26 => [14, 15, 25, 27, 37, 38],
    27 => [15, 16, 26, 28, 38, 39],
    28 => [16, 17, 27, 29, 39, 40],
    29 => [17, 18, 28, 30, 40, 41],
    30 => [18, 19, 29, 31, 41, 42],
    31 => [19, 20, 30, 32, 42, 43],
    32 => [20, 21, 31, 33, 43, 44],
    33 => [21, 22, 32, 34, 44, 45],
    34 => [22, 23, 33, 45, 46],
    35 => [24, 36, 47],
    36 => [24, 25, 35, 37, 47, 48],
    37 => [25, 26, 36, 38, 48, 49],
    38 => [26, 27, 37, 39, 49, 50],
    39 => [27, 28, 38, 40, 50, 51],
    40 => [28, 29, 39, 41, 51, 52],
    41 => [29, 30, 40, 42, 52, 53],
    42 => [30, 31, 41, 43, 53, 54],
    43 => [31, 32, 42, 44, 54, 55],
    44 => [32, 33, 43, 45, 55, 56],
    45 => [33, 34, 44, 46, 56, 57],
    46 => [34, 45, 57],
    47 => [35, 36, 48, 58, 59],
    48 => [36, 37, 47, 49, 59, 60],
    49 => [37, 38, 48, 50, 60, 61],
    50 => [38, 39, 49, 51, 61, 62],
    51 => [39, 40, 50, 52, 62, 63],
    52 => [40, 41, 51, 53, 63, 64],
    53 => [41, 42, 52, 54, 64, 65],
    54 => [42, 43, 53, 55, 65, 66],
    55 => [43, 44, 54, 56, 66, 67],
    56 => [44, 45, 55, 57, 67, 68],
    57 => [45, 46, 56, 68, 69],
    58 => [47, 59, 70],
    59 => [47, 48, 58, 60, 70, 71],
    60 => [48, 49, 59, 61, 71, 72],
    61 => [49, 50, 60, 62, 72, 73],
    62 => [50, 51, 61, 63, 73, 74],
    63 => [51, 52, 62, 64, 74, 75],
    64 => [52, 53, 63, 65, 75, 76],
    65 => [53, 54, 64, 66, 76, 77],
    66 => [54, 55, 65, 67, 77, 78],
    67 => [55, 56, 66, 68, 78, 79],
    68 => [56, 57, 67, 69, 79, 80],
    69 => [57, 68, 80],
    70 => [58, 59, 71, 81, 82],
    71 => [59, 60, 70, 72, 82, 83],
    72 => [60, 61, 71, 73, 83, 84],
    73 => [61, 62, 72, 74, 84, 85],
    74 => [62, 63, 73, 75, 85, 86],
    75 => [63, 64, 74, 76, 86, 87],
    76 => [64, 65, 75, 77, 87, 88],
    77 => [65, 66, 76, 78, 88, 89],
    78 => [66, 67, 77, 79, 89, 90],
    79 => [67, 68, 78, 80, 90, 91],
    80 => [68, 69, 79, 91, 92],
    81 => [70, 82, 93],
    82 => [70, 71, 81, 83, 93, 94],
    83 => [71, 72, 82, 84, 94, 95],
    84 => [72, 73, 83, 85, 95, 96],
    85 => [73, 74, 84, 86, 96, 97],
    86 => [74, 75, 85, 87, 97, 98],
    87 => [75, 76, 86, 88, 98, 99],
    88 => [76, 77, 87, 89, 99, 100],
    89 => [77, 78, 88, 90, 100, 101],
    90 => [78, 79, 89, 91, 101, 102],
    91 => [79, 80, 90, 92, 102, 103],
    92 => [80, 91, 103],
    93 => [81, 82, 94, 104, 105],
    94 => [82, 83, 93, 95, 105, 106],
    95 => [83, 84, 94, 96, 106, 107],
    96 => [84, 85, 95, 97, 107, 108],
    97 => [85, 86, 96, 98, 108, 109],
    98 => [86, 87, 97, 99, 109, 110],
    99 => [87, 88, 98, 100, 110, 111],
    100 => [88, 89, 99, 101, 111, 112],
    101 => [89, 90, 100, 102, 112, 113],
    102 => [90, 91, 101, 103, 113, 114],
    103 => [91, 92, 102, 114, 115],
    104 => [93, 105, 116],
    105 => [93, 94, 104, 106, 116, 117],
    106 => [94, 95, 105, 107, 117, 118],
    107 => [95, 96, 106, 108, 118, 119],
    108 => [96, 97, 107, 109, 119, 120],
    109 => [97, 98, 108, 110, 120, 121],
    110 => [98, 99, 109, 111, 121, 122],
    111 => [99, 100, 110, 112, 122, 123],
    112 => [100, 101, 111, 113, 123, 124],
    113 => [101, 102, 112, 114, 124, 125],
    114 => [102, 103, 113, 115, 125, 126],
    115 => [103, 114, 126],
    116 => [104, 105, 117],
    117 => [105, 106, 116, 118],
    118 => [106, 107, 117, 119],
    119 => [107, 108, 118, 120],
    120 => [108, 109, 119, 121],
    121 => [109, 110, 120, 122],
    122 => [110, 111, 121, 123],
    123 => [111, 112, 122, 124],
    124 => [112, 113, 123, 125],
    125 => [113, 114, 124, 126],
    126 => [114, 115, 125]
  }

  @doc """
  Returns a Board struct with the data specific to a given board.
  """
  def new("japan") do
    %__MODULE__{
      name: "japan",
      players_count: 4,
      regions: %{
        1 => %Region{value: 2, tile_ids: [60, 61, 71, 72]},
        2 => %Region{value: 2, tile_ids: [62, 63, 74]},
        3 => %Region{value: 5, tile_ids: [39, 40, 41, 50, 51, 52]},
        4 => %Region{value: 4, tile_ids: [53, 54, 64, 65]},
        5 => %Region{value: 3, tile_ids: [55, 66, 67]},
        6 => %Region{value: 2, tile_ids: [32, 33, 43, 44]}
      },
      tiles: build_tiles([32, 33, 39, 40, 41, 43, 44, 50, 51, 52, 53, 54, 55, 60, 61, 62, 63, 64, 65, 66, 67, 71, 72, 74])
    }

  end

  def new("earth") do
    %__MODULE__{
      name: "earth",
      players_count: 6,
      regions: %{
        1 => %Region{value: 5, tile_ids: [24, 25, 26, 36, 37, 38, 48, 49, 60]}, # North America
        2 => %Region{value: 2, tile_ids: [72, 83, 84, 95]}, # South America
        3 => %Region{value: 3, tile_ids: [74, 75, 86, 87, 98, 99]}, # Africa
        4 => %Region{value: 5, tile_ids: [39, 40, 41, 51, 52, 63, 64]}, # Europe
        5 => %Region{value: 7, tile_ids: [42, 43, 44, 53, 54, 55, 56, 65, 66, 67, 76, 78]}, # Asia
        6 => %Region{value: 2, tile_ids: [90, 91, 101, 102]} # Australia
      },
      tiles: build_tiles([24, 25, 26, 36, 37, 38, 39, 40, 41, 42, 43, 44, 48, 49, 51, 52, 53, 54, 55, 56, 60, 63, 64, 65, 66, 67, 72, 74, 75, 76, 78, 83, 84, 86, 87, 90, 91, 95, 98, 99, 101, 102])
    }
  end

  @doc """
  Returns a Board struct with the data specific to a given board.
  """
  def new("wheel") do
    %__MODULE__{
      name: "wheel",
      players_count: 6,
      regions: %{
        1 => %Region{value: 3, tile_ids: [15, 26, 27, 37, 39, 48]},
        2 => %Region{value: 3, tile_ids: [16, 17, 18, 19, 30, 41]},
        3 => %Region{value: 3, tile_ids: [31, 43, 55, 65, 66, 67]},
        4 => %Region{value: 3, tile_ids: [78, 87, 89, 99, 100, 111]},
        5 => %Region{value: 3, tile_ids: [85, 96, 107, 108, 109, 110]},
        6 => %Region{value: 3, tile_ids: [59, 60, 61, 71, 83, 95]},
        7 => %Region{value: 6, tile_ids: [51, 52, 62, 63, 64, 74, 75]}
      },
      tiles: build_tiles([15, 16, 17, 18, 19, 26, 27, 30, 31, 37, 39, 41, 43, 48, 51, 52, 55, 59, 60, 61, 62, 63, 64, 65, 66, 67, 71, 74, 75, 78, 83, 85, 87, 89, 95, 96, 99, 100, 107, 108, 109, 110, 111])
    }
  end

  defp build_tiles(tile_ids_for_map) do
    tile_ids_for_map
    |> Enum.map(fn(tile_id) ->
         neighbors = Enum.filter(@all_neighbor_ids[tile_id], fn(neighbor_id) ->
           neighbor_id in tile_ids_for_map
         end)
         {tile_id, Tile.new(neighbors)}
       end)
    |> Enum.into(%{})
  end
end
