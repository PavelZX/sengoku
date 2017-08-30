# Sengoku

## State

```elixir
%{
	winner: nil,
	turnNumber: 2,
	players: %{
		oda: %{
			unplacedArmies: 3
		}
		# etc.
	},
	%{
		territories: %{ # Probably a %Board{} struct
			1 => %{
				owner: :tokugawa,
				armies: 4,
				adjacentTerritories: [3, 4]
			},
			2 => %{
				owner: nil,
				armies: 0,
				adjacentTerritories: [5, 6]
			}
			# etc.
		}
	}
}
```

## Leaders

- Oda Nobunaga
	- https://en.wikipedia.org/wiki/Oda_Nobunaga#/media/File:Ageha-cho.svg
- Toyotomi Hideyoshi
	- https://en.wikipedia.org/wiki/Toyotomi_clan#/media/File:Goshichi_no_kiri_inverted.svg
- Tokugawa Ieyasu
	- https://en.wikipedia.org/wiki/Tokugawa_Ieyasu#/media/File:Tokugawa_family_crest.svg
- Date Masamune
	-  https://en.wikipedia.org/wiki/Date_Masamune#/media/File:Take_ni_Suzume.svg


  ## Articles

  https://www.viget.com/articles/phoenix-and-react-a-killer-combo
