/**
 * Author......: See docs/credits.txt
 * License.....: MIT
 */

#include "inc_vendor.h"
#include "inc_types.h"
#include "inc_platform.h"

#ifdef IS_NATIVE
#define SYNC_THREADS()
#endif

#ifdef IS_CUDA

#if ATTACK_EXEC == 11

CONSTANT_VK u32 generic_constant[8192]; // 32k

#if   ATTACK_KERN == 0
#define bfs_buf     g_bfs_buf
#define rules_buf   ((const kernel_rule_t *) generic_constant)
#define words_buf_s g_words_buf_s
#define words_buf_r g_words_buf_r
#elif ATTACK_KERN == 1
#define bfs_buf     g_bfs_buf
#define rules_buf   g_rules_buf
#define words_buf_s g_words_buf_s
#define words_buf_r g_words_buf_r
#elif ATTACK_KERN == 3
#define rules_buf   g_rules_buf
#define bfs_buf     ((const bf_t *)      generic_constant)
#define words_buf_s ((const bs_word_t *) generic_constant)
#define words_buf_r ((const u32x *)      generic_constant)
#endif

#endif

DECLSPEC u32 atomic_dec (u32 *p)
{
  return atomicSub (p, 1);
}

DECLSPEC u32 atomic_inc (u32 *p)
{
  return atomicAdd (p, 1);
}

DECLSPEC u32 atomic_or (u32 *p, u32 val)
{
  return atomicOr (p, val);
}

DECLSPEC size_t get_global_id  (const u32 dimindx __attribute__((unused)))
{
  return (blockIdx.x * blockDim.x) + threadIdx.x;
}

DECLSPEC size_t get_local_id (const u32 dimindx __attribute__((unused)))
{
  return threadIdx.x;
}

DECLSPEC size_t get_local_size (const u32 dimindx __attribute__((unused)))
{
  // verify
  return blockDim.x;
}

DECLSPEC u32x rotl32 (const u32x a, const int n)
{
  return ((a << n) | ((a >> (32 - n))));
}

DECLSPEC u32x rotr32 (const u32x a, const int n)
{
  return ((a >> n) | ((a << (32 - n))));
}

DECLSPEC u32 rotl32_S (const u32 a, const int n)
{
  return ((a << n) | ((a >> (32 - n))));
}

DECLSPEC u32 rotr32_S (const u32 a, const int n)
{
  return ((a >> n) | ((a << (32 - n))));
}

DECLSPEC u64x rotl64 (const u64x a, const int n)
{
  return ((a << n) | ((a >> (64 - n))));
}

DECLSPEC u64x rotr64 (const u64x a, const int n)
{
  return ((a >> n) | ((a << (64 - n))));
}

DECLSPEC u64 rotl64_S (const u64 a, const int n)
{
  return ((a << n) | ((a >> (64 - n))));
}

DECLSPEC u64 rotr64_S (const u64 a, const int n)
{
  return ((a >> n) | ((a << (64 - n))));
}

#define SYNC_THREADS() __syncthreads ()
#endif

#ifdef IS_OPENCL
#define SYNC_THREADS() barrier (CLK_LOCAL_MEM_FENCE)
#endif
