#include <X11/Xlib.h>
#include <Imlib2.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct Monitor {
	Display *display;
	Window root;
} Monitor;

Monitor *init_monitor() {
	Monitor *mon = malloc(sizeof(Monitor));
	if (!mon) {
		fprintf(stderr, "Error: Failed to allocate memory for Monitor struct.\n");
		exit(EXIT_FAILURE);
	}

	mon->display = XOpenDisplay(NULL);
	if (!mon->display) {
		fprintf(stderr, "Error: Could not open X display.\n");
		free(mon);
		exit(EXIT_FAILURE);
	}

	mon->root = RootWindow(mon->display, DefaultScreen(mon->display));
	return mon;
}

void take_screenshot(Monitor *mon, int x, int y, int width, int height, const char *filename) {
	Imlib_Image image = imlib_create_image(width, height);
	if (!image) {
		fprintf(stderr, "Error: Failed to create an Imlib2 image.\n");
		XCloseDisplay(mon->display);
		free(mon);
		exit(EXIT_FAILURE);
	}

	imlib_context_set_image(image);
	imlib_context_set_display(mon->display);
	imlib_context_set_visual(DefaultVisual(mon->display, 0));
	imlib_context_set_drawable(mon->root);

	imlib_copy_drawable_to_image(0, x, y, width, height, 0, 0, 1);

	imlib_save_image(filename);
	printf("Screenshot of (%d, %d, %d, %d) saved to: %s\n", x, y, width, height, filename);

	imlib_free_image();
	XCloseDisplay(mon->display);
	free(mon);
}

int main(int argc, char **argv) {
	/*for (int i = 1; i < )*/

	if (argc < 6) {
		fprintf(stderr, "Usage: %s <x> <y> <width> <height> <filename>\n", argv[0]);
		return EXIT_FAILURE;
	}

	int x = atoi(argv[1]);
	int y = atoi(argv[2]);
	int width = atoi(argv[3]);
	int height = atoi(argv[4]);
	const char *filename = argv[5];

	Monitor *selmon = init_monitor();

	// take partal screenshot
	take_screenshot(selmon, x, y, width, height, filename);

	return 0;
}
