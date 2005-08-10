/* $Id: init.c,v 1.2 2005/08/10 12:41:33 kir Exp $
 * Init -- very simple init stub
 * Shamelessly borrowed from old vzpkgtools.
 *
 * Copyright (C) 2004, 2005, SWsoft. Licensed under QPL.
 */

#include <sys/types.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <stdio.h>
#include <signal.h>

/* Set a signal handler */
static void setsig(struct sigaction *sa, int sig, 
		   void (*fun)(int), int flags)
{
	sa->sa_handler = fun;
	sa->sa_flags = flags;
	sigemptyset(&sa->sa_mask);
	sigaction(sig, sa, NULL);
}

/*
 * SIGCHLD: one of our children has died.
 */
void chld_handler()
{
	int st;

	/* R.I.P. all children */
	while((waitpid(-1, &st, WNOHANG)) > 0)
		;
}


/*
 * The main loop
 */ 
int main(int argc, char * argv[])
{
	struct sigaction sa;
	int i;

	if (geteuid() != 0) {
		fprintf(stderr, "%s: must be superuser\n", argv[0]);
		exit(1);
	}

	if (getpid() != 1) {
		fprintf(stderr, "%s: must be a process with PID=1\n", argv[0]);
		exit(1);
	}

	/* Ignore all signals */
	for(i = 1; i <= NSIG; i++)
		setsig(&sa, i, SIG_IGN, SA_RESTART);

	setsig(&sa, SIGCHLD, chld_handler, SA_RESTART);

	close(0);
	close(1);
	close(2);
  	setsid();


	for(;;)
		pause();
}
