trigger ContactTrigger on Contact (before insert) {
system.debug('Testing trigger');
}