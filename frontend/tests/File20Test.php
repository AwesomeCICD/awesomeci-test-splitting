<?php
use PHPUnit\Framework\TestCase;
use Demo\File20;

class File20Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File20::add(2, 3));
    }
}
