const { expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');

const SeedPhaseERC777 = artifacts.require('SeedPhaseERC777');
const TokenERC777 = artifacts.require("TokenERC777");

contract('SeedPhaseERC777', function (owner) {

    let token;
    let seed;

    beforeEach(async function () {
        const erc777 = await TokenERC777.new([]);
        this.seedPhaseERC777 = await SeedPhaseERC777.new(
            erc777.address,
            [1000, 500, 250],
            [
                "0x32289C3688CEbf515A065E7D25DC5cEFDb6E9c12",
                "0xCd552D7066da507FD9870a82A319953f713d542B",
                "0xeC097800387fE89F22297f2Eebb386bAD9ed4CC5"
            ]);

        token = await TokenERC777.deployed();
        seed = await SeedPhaseERC777.deployed();
    });

    it('reverts transaction to seed contract when tokens already received or amount is not valid', async function () {
        await expectRevert(
            token.send(seed.address, 1, []),
            'tokens already received or amount is not valid',
        );
    });

    it('reverts transaction to seed contract when token is not valid', async function () {
        await expectRevert(
            seed.tokensReceived(
                owner[0],
                owner[0],
                seed.address,
                1,
                "0x0",
                "0x0"
            ),
            'invalid token',
        );
    });

    it('reverts transfer to investors when contract don\'t have any tokens', async function () {
        await expectRevert(
            seed.transferToInvestors(60),
            'contract don\'t have any tokens',
        );
    });

    it('reverts transfer to investors when percentage is not valid', async function () {
        await expectRevert(
            seed.transferToInvestors(146),
            'percentage is not valid, you can send only 100 percents',
        );
        await expectRevert(
            seed.transferToInvestors(10000000000000000000000n),
            'percentage is not valid, you can send only 100 percents',
        );
        await expectRevert(
            seed.transferToInvestors(0),
            'percentage is not valid, you can send only 100 percents',
        );
    });

    it('reverts transfer to investors when percentage value out of bounds', async function () {
        await expectRevert(
            seed.transferToInvestors(-25),
            'value out-of-bounds (argument="percentage", value=-25, code=INVALID_ARGUMENT, version=abi/5.0.7)',
        );
    });

    it('_isTokenReceived "false" before tokens received', async function () {
        expect((await seed.isTokenReceived()).toString())
            .to.be.equal('false');
    });

    it('balance of contract changed after valid transaction', async function () {
        await token.send(seed.address, 1750000000000000000000n, []);
        expect((await seed.getTokensAmount()).toString())
            .to.be.equal('1750000000000000000000');
    });

    it('_isTokenReceived "true" after tokens received', async function () {
        expect((await seed.isTokenReceived()).toString())
            .to.be.equal('true');
    });

    it('promised tokens amount equals actual promised tokens amount of seed contract', async function () {
        expect((await seed.getPromisedTokensAmount()).toString())
            .to.be.equal('1750000000000000000000');
    });

    it('investors have zero tokens before seed contract transaction', async function () {
        expect((await token.balanceOf("0x32289C3688CEbf515A065E7D25DC5cEFDb6E9c12")).toString()).to.be.equal('0');
        expect((await token.balanceOf("0xCd552D7066da507FD9870a82A319953f713d542B")).toString()).to.be.equal('0');
        expect((await token.balanceOf("0xeC097800387fE89F22297f2Eebb386bAD9ed4CC5")).toString()).to.be.equal('0');
    });

    it('investors have a half of promised tokens after seed contract 50 percent transaction to them', async function () {
        await seed.transferToInvestors(50);
        expect((await token.balanceOf("0x32289C3688CEbf515A065E7D25DC5cEFDb6E9c12")).toString()).to.be.equal('500000000000000000000');
        expect((await token.balanceOf("0xCd552D7066da507FD9870a82A319953f713d542B")).toString()).to.be.equal('250000000000000000000');
        expect((await token.balanceOf("0xeC097800387fE89F22297f2Eebb386bAD9ed4CC5")).toString()).to.be.equal('125000000000000000000');
    });

    it('reverts transfer to investors when percentage is more then already paid before', async function () {
        await expectRevert(
            seed.transferToInvestors(51),
            'percentage is not valid, you can send only 50 percents',
        );
    });

    it('investors have all promised tokens after seed contract 50 percent transaction to them', async function () {
        await seed.transferToInvestors(50);
        expect((await token.balanceOf("0x32289C3688CEbf515A065E7D25DC5cEFDb6E9c12")).toString()).to.be.equal('1000000000000000000000');
        expect((await token.balanceOf("0xCd552D7066da507FD9870a82A319953f713d542B")).toString()).to.be.equal('500000000000000000000');
        expect((await token.balanceOf("0xeC097800387fE89F22297f2Eebb386bAD9ed4CC5")).toString()).to.be.equal('250000000000000000000');
    });

    it('seed contract don\'t have any tokens after transaction to investors', async function () {
        expect((await token.balanceOf(seed.address)).toString()).to.be.equal('0');
    });
});
