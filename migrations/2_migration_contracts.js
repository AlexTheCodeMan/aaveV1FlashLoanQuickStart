const FLExampleV1 = artifacts.require("./FLExampleV1.sol");


module.exports = function(deployer) {
    deployer.deploy(FLExampleV1);
}
