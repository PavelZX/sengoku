import React from 'react'
import playerUI from '../playerUI'

const Player = (props) => {
  const styles = {
    backgroundColor: playerUI[props.id].color,
  }

  return (
    <li className={props.selected ? 'Player Player--active' : 'Player'} style={styles}>
      <b>{playerUI[props.id].name}</b>
      <span>{props.unplacedArmies} 兵</span>
    </li>
  )
}

export default Player
