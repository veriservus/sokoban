defmodule Sokoban.Assets do
  use Scenic.Assets.Static,
    otp_app: :sokoban,
  sources: ["assets"],
  alias: [
    box: "box.png",
    hero: "hero.png",
    hero_hole: "hero-hole.png",
    hole: "hole.png",
    wall: "wall.png",
    box_hole: "box-hole.png"
  ]
end
