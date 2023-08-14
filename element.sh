#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

str=$1
len=${#str}

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number='$1'")
  fi
  if [[ $1 =~ ^[A-Za-z]+$ && $len -le 2 ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
  fi
  if [[ $1 =~ ^[A-Za-z]+$ && $len -gt 2 ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
  fi

  if [[ -z $ATOMIC_NUMBER ]]
  then
  echo "I could not find that element in the database."
  else
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number='$ATOMIC_NUMBER'")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number='$ATOMIC_NUMBER'")
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id='$TYPE_ID'")
    MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")
    MELT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")
    BOIL=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  fi
fi

##done



