:::::::::::::::::::::::::::::::::::::
:: Make EggDrop Bots High as Fuck  ::
:: Script Written by Zetacon       ::
:: All Rights Reserved             ::
:::::::::::::::::::::::::::::::::::::

Ideas
1. Provide an on/off switch to prevent misuse.
2. Insert more synonyms for MJ? I feel like I covered a lot of them, but I could have missed some.
3. Ability to select the amount of synonyms used. The user can execute /high Xena # and the script can select the number in the list or select random items.
4. Set this so that it only selects a nick in a channel.
5. Provide switches to lock it down to a certain channel for customization purposes.
6. Give the end user the ability to insert more synonyms that can read from a file, etc.

alias high {
  if ($1 == Xena) {
    .timer 1 1 describe $chan gives $1 a bong.
    .timer 1 7 describe $chan gives $1 a spliff.
    .timer 1 14 describe $chan gives $1 some herbal refreshment.
    .timer 1 21 describe $chan gives $1 a joint.
    .timer 1 28 describe $chan gives $1 a pipe.
    .timer 1 35 describe $chan gives $1 some cannabis.42-
    .timer 1 42 describe $chan gives $1 some Acapulco gold.
    .timer 1 49 describe $chan gives $1 some reefer.
    .timer 1 56 describe $chan gives $1 some hemp.
    .timer 1 63 describe $chan gives $1 some dope.
    .timer 1 70 describe $chan gives $1 some bhang.
    .timer 1 77 describe $chan gives $1 some hashish.
    .timer 1 84 describe $chan gives $1 some ganja.
    .timer 1 91 describe $chan gives $1 some roach.
    .timer 1 98 describe $chan gives $1 some Maui wowie.
    .timer 1 105 describe $chan gives $1 some Panama Red.
    .timer 1 112 describe $chan gives $1 a doobie.
    .timer 1 119 describe $chan gives $1 some loco weed.
    .timer 1 126 describe $chan gives $1 some maryjane.
    .timer 1 133 describe $chan gives $1 some pot.
    .timer 1 140 describe $chan gives $1 some sinsemilla.
    .timer 1 147 msg $chan How are you feeling $1 $+ ?
  }
}