#ifndef __SETPROCTITLE_H__
#define __SETPROCTITLE_H__

#ifdef __cplusplus
extern "C" {
#endif

#ifndef SPT_MAXTITLE
#define SPT_MAXTITLE 255
#endif

void spt_init(int argc, char *argv[]);
void setproctitle(const char *fmt, ...);

#ifdef __cplusplus
}
#endif

#endif /* __SETPROCTITLE_H__ */