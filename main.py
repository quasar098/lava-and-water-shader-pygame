import pygame
import moderngl
from shader import *
from array import array

pygame.init()

WIDTH, HEIGHT = 1280, 720
FRAMERATE = 75

pygame.display.set_mode([WIDTH, HEIGHT], pygame.OPENGL | pygame.HWACCEL | pygame.HWSURFACE | pygame.DOUBLEBUF)
pygame.display.set_caption("Lava shader (click for water)")
screen = pygame.Surface([WIDTH, HEIGHT])
ctx = moderngl.create_context()

quad_buffer = ctx.buffer(data=array('f', [
    -1.0, 1.0, 0.0, 0.0,   # topleft
    1.0, 1.0, 1.0, 0.0,    # topright
    -1.0, -1.0, 0.0, 1.0,  # bottomleft
    1.0, -1.0, 1.0, 1.0,   # bottomright
]))

program = ctx.program(vertex_shader=vert_shader, fragment_shader=frag_shader)
vertex_array = ctx.vertex_array(program, [(quad_buffer, '2f 2f', 'vert', 'texcoord')])


def surf_to_moderngl_texture(surf: pygame.Surface) -> moderngl.Texture:
    tex = ctx.texture(surf.get_size(), 4)
    tex.filter = (moderngl.LINEAR, moderngl.LINEAR)
    tex.swizzle = "BGRA"
    tex.write(surf.get_view('1'))
    return tex


surf_to_moderngl_texture(pygame.image.load("./noise.png").convert_alpha()).use(1)

clock = pygame.time.Clock()
dt = 0
color_scheme = 0

running = True
while running:
    screen.fill((0, 0, 0))
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        if event.type == pygame.MOUSEBUTTONDOWN:
            if event.button == 1:
                color_scheme = 1 - color_scheme
                if color_scheme:
                    pygame.display.set_caption("Water shader (click for lava)")
                else:
                    pygame.display.set_caption("Lava shader (click for water)")

    # moderngl stuff
    frame_tex = surf_to_moderngl_texture(screen)
    frame_tex.use(0)
    program['in_tex'] = 0
    program['iChannel0'] = 1
    program['iTime'] = pygame.time.get_ticks()
    program['colorScheme'] = color_scheme
    # noinspection PyTypeChecker
    vertex_array.render(mode=moderngl.TRIANGLE_STRIP)
    pygame.display.flip()
    frame_tex.release()
    dt = clock.tick(FRAMERATE) / 1000
pygame.quit()
