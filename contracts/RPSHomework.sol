// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract RPSHomework {
    enum GameState {
        Commit,
        Reveal,
        Complete
    }

    enum GameChoice {
        None,
        Rock,
        Paper,
        Scissors
    }

    struct Game {
        GameState state;
        address winner;
        address[2] players; // maybe multiplayer support? :)
        bytes32[2] commitHashes;
        GameChoice[2] choices;
    }

    Game[] public games;

    event PlayerPerformedCommit (
        uint256 indexed gameIndex,
        address indexed player
    );

    event PlayerPerformedReveal (
        uint256 indexed gameIndex,
        address indexed player,
        GameChoice choice
    );

    event GameStarted (
        uint256 indexed gameIndex,
        address indexed initiator,
        address indexed challenger
    );

    event GameFinished (
        uint256 indexed gameIndex,
        address indexed winner
    );

    modifier validGameIndex(uint256 _gameIndex) {
        require(_gameIndex >= 0, "game index should be non-negative");
        require(_gameIndex < games.length, "game index should be less than overall games count");
        _;
    }

    modifier updateState(uint256 _gameIndex) {
        _;

        Game storage game = games[_gameIndex];

        for (uint256 i = 0; i < game.players.length; i++) {
            if (game.commitHashes[i] == 0) {
                // at least one person did not commit => state = commit
                game.state = GameState.Commit;
                return;
            }
        }

        for (uint256 i = 0; i < game.players.length; i++) {
            if (game.choices[i] == GameChoice.None) {
                // at least one person did not make a choice => state = reveal
                game.state = GameState.Reveal;
                return;
            }
        }
        
        // all have their commits and choices => finish

        address winner;

        if(game.choices[0] == game.choices[1]) {
            winner = address(0x0);
        }
        else if(game.choices[0] == GameChoice.Rock) {
            if(game.choices[1] == GameChoice.Paper) {
                winner = game.players[1];
            }
            else if(game.choices[1] == GameChoice.Scissors) {
                winner = game.players[0];
            } else revert("invalid choice");
        }
        else if(game.choices[0] == GameChoice.Paper) {
            if(game.choices[1] == GameChoice.Rock) {
                winner = game.players[0];
            }
            else if(game.choices[1] == GameChoice.Scissors) {
                winner = game.players[1];
            } else revert("invalid choice");
        }
        else if(game.choices[0] == GameChoice.Scissors) {
            if(game.choices[1] == GameChoice.Rock) {
                winner = game.players[1];
            }
            else if(game.choices[1] == GameChoice.Paper) {
                winner = game.players[0];
            } else revert("invalid choice");
        }
        else revert("invalid choice");

        game.state = GameState.Complete;
        game.winner = winner;

        emit GameFinished(_gameIndex, winner);
    }

    function start(
        address _anotherPlayer
    ) public {
        require(_anotherPlayer != address(0x0), "player-challenger can't be a null address");
        require(_anotherPlayer != msg.sender, "you can't be challenging yourself!");

        Game memory game;

        game.state = GameState.Commit;
        game.players[0] = msg.sender;
        game.players[1] = _anotherPlayer;

        games.push(
            game
        );

        emit GameStarted(
            games.length - 1,
            msg.sender,
            _anotherPlayer
        );
    }

    function commit(
        uint256 _gameIndex,
        bytes32 _hash
    ) public validGameIndex(_gameIndex) updateState(_gameIndex) {
        require(_hash.length > 1, "hash should be longer than 1 symbol");

        Game storage game = games[_gameIndex];

        require(game.state == GameState.Commit, "you cannot commit at this game's state");

        bool found = false;

        for (uint256 i = 0; i < game.players.length; i++) {
            if (game.players[i] == msg.sender) {
                game.commitHashes[i] = _hash;

                emit PlayerPerformedCommit(
                    _gameIndex,
                    msg.sender
                );

                found = true;
                break;
            }
        }

        if (!found)
            revert("user is not a player");
    }

    function reveal(
        uint256 _gameIndex,
        GameChoice _choice,
        bytes32 _salt
    ) public validGameIndex(_gameIndex) updateState(_gameIndex) {
        require(_salt.length > 1, "salt should be longer than 1 symbol");
        require(_choice == GameChoice.Rock 
            || _choice == GameChoice.Paper 
            || _choice == GameChoice.Scissors, "choice should be defined");

        Game storage game = games[_gameIndex];

        require(game.state == GameState.Reveal, "you cannot reveal at this game's state");

        bool found = false;

        for (uint256 i = 0; i < game.players.length; i++) {
            if (game.players[i] == msg.sender) {
                require(uint(game.choices[i]) == 0, "you cannot reveal more than one time");
                require(keccak256(abi.encodePacked(
                    msg.sender,
                    _gameIndex,
                    uint(_choice),
                    _salt
                )) == game.commitHashes[i], "hash in commit was not the same as the one provided");

                game.choices[i] = _choice;

                emit PlayerPerformedReveal(
                    _gameIndex,
                    msg.sender,
                    _choice
                );

                found = true;
                break;
            }
        }

        if (!found)
            revert("user is not a player");
    }

    function getGame(uint256 _gameIndex)
        external
        view
        returns (Game memory)
    {
        return games[_gameIndex];
    }
}
 
